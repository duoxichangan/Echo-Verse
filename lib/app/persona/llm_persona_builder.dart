import '../../domain/contracts/chat_log_parser.dart';
import '../../domain/contracts/model_adapter.dart';
import '../../domain/contracts/persona_builder.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/models/persona_profile.dart';
import '../../prompts/persona_prompts.dart';
import 'json_extract.dart';

/// 人格提炼实现（手册 PERSONA-02 / 说明书 §8.1）。
class LlmPersonaBuilder implements PersonaBuilder {
  final ModelAdapter adapter;

  const LlmPersonaBuilder(this.adapter);

  @override
  Future<PersonaProfile> build(ParsedLog log, PersonaHints hints) async {
    final target = hints.targetSpeaker ??
        (log.speakers.isNotEmpty ? log.speakers.first : hints.name);

    final buf = StringBuffer();
    await for (final chunk in adapter.chat(
      system: PersonaPrompts.buildSystem,
      messages: [
        Msg.user(PersonaPrompts.buildUser(
          parsedConversation: log.toConversationText(),
          targetSpeaker: target,
          relationship: hints.relationship,
          userAlias: hints.userAlias,
          personalityHints: hints.personalityHints,
        )),
      ],
      opts: const ChatOpts(temperature: 0.7),
    )) {
      buf.write(chunk);
    }

    final json = extractJsonObject(buf.toString());
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
}
