import 'dart:async';

import 'package:drift/drift.dart';

import '../../data/db/database.dart';
import '../../domain/contracts/chat_engine.dart';
import '../../domain/contracts/context_assembler.dart';
import '../../domain/contracts/memory_service.dart';
import '../../domain/contracts/model_adapter.dart';
import '../../domain/contracts/output_post_processor.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/models/rendered_message.dart';

/// 对话引擎实现（手册 CHAT-02）。
///
/// 一回合编排：
///  1. 落库用户消息；
///  2. 取最近原文 → [ContextAssembler.assemble] 组装 Prompt；
///  3. [ModelAdapter.chat] 流式生成；
///  4. [OutputPostProcessor.process] 分条/解析表情/估算延迟；
///  5. 按每条 delayMs 逐条 yield，并把每条落库为一行 persona 消息（连发即多行）；
///  6. 每累计 [extractEvery] 条新消息，后台静默触发一次记忆提炼（MEM-02，不阻塞回复）。
///
/// LLM 依赖只经 [ModelAdapter]，可用 MockAdapter 离线跑通整条闭环。
class ChatEngineImpl implements ChatEngine {
  final AppDatabase db;
  final ContextAssembler assembler;
  final ModelAdapter adapter;
  final OutputPostProcessor postProcessor;

  /// 记忆服务，用于每 M 轮提炼（MEM-02）；null 则不提炼。
  final MemoryService? memoryService;

  /// 组装上下文用的 token 预算。
  final int budgetTokens;

  /// 取最近多少条原文喂给组装器。
  final int recentWindow;

  /// 每累计多少条新消息触发一次记忆提炼。
  final int extractEvery;

  /// 取当前时间戳（毫秒）；注入便于测试。
  final int Function() nowMs;

  /// 测试可关掉真实延迟（默认 true=按 delayMs 等待，拟真节奏）。
  final bool honorDelays;

  /// 测试可关掉后台提炼的“fire-and-forget”，改为同步等待（默认 false）。
  final bool awaitExtraction;

  /// 各 persona 自上次提炼后累计的新消息数（内存计数）。
  final Map<int, int> _sinceExtract = {};

  ChatEngineImpl({
    required this.db,
    required this.assembler,
    required this.adapter,
    required this.postProcessor,
    this.memoryService,
    this.budgetTokens = 4000,
    this.recentWindow = 20,
    this.extractEvery = 6,
    int Function()? nowMs,
    this.honorDelays = true,
    this.awaitExtraction = false,
  }) : nowMs = nowMs ?? (() => DateTime.now().millisecondsSinceEpoch);

  @override
  Stream<RenderedMessage> send(int personaId, String userMsg) async* {
    // 1) 落库用户消息。
    await _insert(personaId, sender: 'user', content: userMsg, type: 'text');

    // 2) 取最近原文（含刚落库的用户消息），转成模型消息。
    final recent = await _recentMsgs(personaId);

    // 3) 组装 Prompt。
    final prompt = await assembler.assemble(personaId, recent, budgetTokens);

    // 4) 调模型 → 后处理分条。
    final rawStream = adapter.chat(
      system: prompt.system,
      messages: prompt.messages,
    );
    final rendered =
        await postProcessor.process(rawStream, personaId: personaId);

    // 5) 逐条 yield + 落库。
    for (final m in rendered) {
      if (honorDelays && m.delayMs > 0) {
        await Future<void>.delayed(Duration(milliseconds: m.delayMs));
      }
      if (m.kind == RenderedKind.sticker) {
        await _insert(personaId,
            sender: 'persona', content: m.stickerPath ?? '', type: 'sticker');
      } else {
        // 落库用 rawContent（保留 [记住:] 供 MEM-02），展示用 m.content。
        await _insert(personaId,
            sender: 'persona', content: m.rawContent ?? m.content ?? '', type: 'text');
      }
      yield m;
    }

    // 6) 每累计 extractEvery 条新消息，触发一次记忆提炼（MEM-02）。
    //    本回合新增 = 1 条用户 + rendered.length 条回复。
    final added = 1 + rendered.length;
    final maybeExtract = _accumulateAndMaybeExtract(personaId, added);
    if (awaitExtraction) {
      await maybeExtract;
    } else {
      // 后台静默：不阻塞回复流，提炼失败也不影响对话。
      unawaited(maybeExtract);
    }
  }

  /// 累计新消息数；达阈值则取最近一段对话交记忆服务提炼，并清零计数。
  Future<void> _accumulateAndMaybeExtract(int personaId, int added) async {
    final svc = memoryService;
    if (svc == null) return;
    final count = (_sinceExtract[personaId] ?? 0) + added;
    if (count < extractEvery) {
      _sinceExtract[personaId] = count;
      return;
    }
    _sinceExtract[personaId] = 0;
    try {
      // 提炼最近 count 条（至少 extractEvery）新消息。
      final recent = await _recentMsgs(personaId, limit: count);
      await svc.extract(personaId, recent);
    } catch (_) {
      // 提炼失败不影响对话；下一轮重新累计。
    }
  }

  Future<void> _insert(
    int personaId, {
    required String sender,
    required String content,
    required String type,
  }) async {
    final ts = nowMs();
    await db.into(db.messages).insert(MessagesCompanion.insert(
          personaId: personaId,
          sender: sender,
          content: content,
          type: Value(type),
          createdAt: ts,
          // 交互式回复在聊天页打开、消息正显示在屏幕上时生成 → 生而即读。
          // 这样即便用户在「对方正在输入」期间退出，流的后续分条落库也不会
          // 残留成未读（红点）。主动消息走另一条路径（Bootstrap），保持未读。
          readAt: Value(sender == 'persona' ? ts : null),
        ));
  }

  /// 取最近 [limit]（默认 [recentWindow]）条消息，按时间升序转成模型 [Msg]。
  Future<List<Msg>> _recentMsgs(int personaId, {int? limit}) async {
    final rows = await (db.select(db.messages)
          ..where((m) => m.personaId.equals(personaId))
          ..orderBy([(m) => OrderingTerm.desc(m.createdAt)])
          ..limit(limit ?? recentWindow))
        .get();
    // 倒序取出后翻正，得到时间升序。
    final ordered = rows.reversed;
    return [
      for (final r in ordered)
        Msg(r.sender == 'user' ? Role.user : Role.assistant, r.content),
    ];
  }
}
