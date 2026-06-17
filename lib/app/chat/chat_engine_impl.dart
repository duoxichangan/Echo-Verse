import 'package:drift/drift.dart';

import '../../data/db/database.dart';
import '../../domain/contracts/chat_engine.dart';
import '../../domain/contracts/context_assembler.dart';
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
///  5. 按每条 delayMs 逐条 yield，并把每条落库为一行 persona 消息（连发即多行）。
///
/// LLM 依赖只经 [ModelAdapter]，可用 MockAdapter 离线跑通整条闭环。
class ChatEngineImpl implements ChatEngine {
  final AppDatabase db;
  final ContextAssembler assembler;
  final ModelAdapter adapter;
  final OutputPostProcessor postProcessor;

  /// 组装上下文用的 token 预算。
  final int budgetTokens;

  /// 取最近多少条原文喂给组装器。
  final int recentWindow;

  /// 取当前时间戳（毫秒）；注入便于测试。
  final int Function() nowMs;

  /// 测试可关掉真实延迟（默认 true=按 delayMs 等待，拟真节奏）。
  final bool honorDelays;

  ChatEngineImpl({
    required this.db,
    required this.assembler,
    required this.adapter,
    required this.postProcessor,
    this.budgetTokens = 4000,
    this.recentWindow = 20,
    int Function()? nowMs,
    this.honorDelays = true,
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
        await _insert(personaId,
            sender: 'persona', content: m.content ?? '', type: 'text');
      }
      yield m;
    }
  }

  Future<void> _insert(
    int personaId, {
    required String sender,
    required String content,
    required String type,
  }) async {
    await db.into(db.messages).insert(MessagesCompanion.insert(
          personaId: personaId,
          sender: sender,
          content: content,
          type: Value(type),
          createdAt: nowMs(),
        ));
  }

  /// 取最近 [recentWindow] 条消息，按时间升序转成模型 [Msg]。
  Future<List<Msg>> _recentMsgs(int personaId) async {
    final rows = await (db.select(db.messages)
          ..where((m) => m.personaId.equals(personaId))
          ..orderBy([(m) => OrderingTerm.desc(m.createdAt)])
          ..limit(recentWindow))
        .get();
    // 倒序取出后翻正，得到时间升序。
    final ordered = rows.reversed;
    return [
      for (final r in ordered)
        Msg(r.sender == 'user' ? Role.user : Role.assistant, r.content),
    ];
  }
}
