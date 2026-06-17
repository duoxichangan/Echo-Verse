import '../../domain/contracts/chat_log_parser.dart';
import '../../domain/contracts/model_adapter.dart';
import '../../domain/contracts/persona_builder.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/models/persona_profile.dart';
import '../../prompts/persona_prompts.dart';
import 'json_extract.dart';

/// 人格提炼实现（手册 PERSONA-02 / 说明书 §8.1）。
///
/// 超长记录走 map-reduce 多轮凝练：分批读完全部消息（每批 [batchSize] 条），
/// 每批提炼"观察笔记"(map)，再把所有笔记汇总成最终 L0–L5 画像(reduce)。
/// 短记录（≤1 批）直接单次提炼。
class LlmPersonaBuilder implements PersonaBuilder {
  final ModelAdapter adapter;

  /// 每批消息条数。批太大会超 LLM 输入上限，太小则调用次数多。
  final int batchSize;

  const LlmPersonaBuilder(this.adapter, {this.batchSize = 300});

  @override
  Future<PersonaProfile> build(
    ParsedLog log,
    PersonaHints hints, {
    void Function(int done, int total)? onProgress,
  }) async {
    final target = hints.targetSpeaker ??
        (log.speakers.isNotEmpty ? log.speakers.first : hints.name);

    final msgs = log.messages;
    Map<String, dynamic>? json;

    if (msgs.length <= batchSize) {
      // 短记录：单次提炼。
      onProgress?.call(0, 1);
      json = await _completeJson(
        system: PersonaPrompts.buildSystem,
        user: PersonaPrompts.buildUser(
          parsedConversation: log.toConversationText(maxMessages: batchSize),
          targetSpeaker: target,
          relationship: hints.relationship,
          userAlias: hints.userAlias,
          personalityHints: hints.personalityHints,
        ),
        temperature: 0.7,
      );
      onProgress?.call(1, 1);
    } else {
      // 长记录：map-reduce 多轮凝练。
      final batches = _chunk(msgs, batchSize);
      // 总步数 = 各批 map + 1 次 reduce。
      final total = batches.length + 1;
      final notes = StringBuffer();

      for (var i = 0; i < batches.length; i++) {
        onProgress?.call(i, total);
        final convo = _conversationOf(batches[i]);
        final note = await _completeText(
          system: PersonaPrompts.batchSystem,
          user: PersonaPrompts.batchUser(
            targetSpeaker: target,
            batchIndex: i + 1,
            batchTotal: batches.length,
            conversation: convo,
          ),
          temperature: 0.4,
        );
        if (note.trim().isNotEmpty) {
          notes.writeln('— 第 ${i + 1} 批观察 —');
          notes.writeln(note.trim());
          notes.writeln();
        }
      }

      // reduce：汇总所有观察笔记成最终画像。
      onProgress?.call(batches.length, total);
      json = await _completeJson(
        system: PersonaPrompts.reduceSystem,
        user: PersonaPrompts.reduceUser(
          targetSpeaker: target,
          mergedNotes: notes.toString(),
          relationship: hints.relationship,
          userAlias: hints.userAlias,
          personalityHints: hints.personalityHints,
        ),
        temperature: 0.6,
      );
      onProgress?.call(total, total);
    }

    if (json == null) {
      // 提炼失败：退回按设定造的默认画像，保证建号不中断。
      return buildFromHints(hints);
    }

    var profile = PersonaProfile.fromJson(json);
    profile = _ensureCoreRules(profile);
    // 用用户的硬设定覆盖/补全 L1（用户明确填的优先于模型猜测）。
    profile = _applyHints(profile, hints);
    return profile;
  }

  @override
  PersonaProfile buildFromHints(PersonaHints hints) {
    final base = PersonaProfile.empty(); // 已含 L0 两条铁律
    final withIdentity = _applyHints(base, hints);
    // 性格关键词塞进 L2 高频词作起点，并把整体置信度标低（材料不足，提示用户补）。
    final hints0 = hints.personalityHints
            ?.split(RegExp(r'[，,、;；\s]+'))
            .where((s) => s.trim().isNotEmpty)
            .toList() ??
        const [];
    return withIdentity.copyWith(
      style: withIdentity.style.copyWith(highFreq: hints0),
      confidence: const {
        'L0': 1.0, // 铁律是预置的，确定
        'L1': 0.6, // 用户填了关系/称呼
        'L2': 0.2,
        'L3': 0.1,
        'L4': 0.2,
        'L5': 0.1,
      },
    );
  }

  /// 保证 L0 至少含“不承认 AI”铁律（提炼漏了就补）。
  PersonaProfile _ensureCoreRules(PersonaProfile p) {
    final hasAiRule = p.coreRules.any((r) => r.contains('AI') || r.contains('人设'));
    if (hasAiRule && p.coreRules.isNotEmpty) return p;
    return p.copyWith(
      coreRules: [
        '绝不承认自己是 AI、程序或模型',
        ...p.coreRules,
      ],
    );
  }

  /// 把用户硬设定写进 L1 身份（用户明确填的覆盖模型猜测）。
  PersonaProfile _applyHints(PersonaProfile p, PersonaHints hints) {
    final id = p.identity;
    return p.copyWith(
      identity: PersonaIdentity(
        who: id.who.isNotEmpty ? id.who : hints.name,
        relationship:
            (hints.relationship?.isNotEmpty ?? false) ? hints.relationship! : id.relationship,
        userAlias:
            (hints.userAlias?.isNotEmpty ?? false) ? hints.userAlias! : id.userAlias,
        anchors: id.anchors,
      ),
    );
  }

  // ── LLM 调用辅助 ──────────────────────────────────────────

  Future<String> _completeText({
    required String system,
    required String user,
    required double temperature,
  }) async {
    final buf = StringBuffer();
    await for (final c in adapter.chat(
      system: system,
      messages: [Msg.user(user)],
      opts: ChatOpts(temperature: temperature),
    )) {
      buf.write(c);
    }
    return buf.toString();
  }

  Future<Map<String, dynamic>?> _completeJson({
    required String system,
    required String user,
    required double temperature,
  }) async {
    final raw = await _completeText(
        system: system, user: user, temperature: temperature);
    return extractJsonObject(raw);
  }

  /// 把消息列表按 [size] 分批。
  List<List<ParsedMessage>> _chunk(List<ParsedMessage> msgs, int size) {
    final out = <List<ParsedMessage>>[];
    for (var i = 0; i < msgs.length; i += size) {
      out.add(msgs.sublist(i, (i + size).clamp(0, msgs.length)));
    }
    return out;
  }

  /// 一批消息拼成可读对话文本。
  String _conversationOf(List<ParsedMessage> batch) {
    final b = StringBuffer();
    for (final m in batch) {
      b.writeln('${m.speaker}: ${m.content}');
    }
    return b.toString();
  }
}
