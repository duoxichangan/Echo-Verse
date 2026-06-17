import '../models/persona_profile.dart';
import 'chat_log_parser.dart';

/// 用户在建号时补充的关键设定（半自动建号，说明书 §11.2）。
class PersonaHints {
  /// 数字人昵称。
  final String name;

  /// 被复刻对象在聊天记录里的说话人标签（导入路径用；直接创建可空）。
  final String? targetSpeaker;

  /// 关系（女友/好友/家人…）。
  final String? relationship;

  /// TA 对用户的称呼。
  final String? userAlias;

  /// 性格关键词（自由文本，逗号或顿号分隔）。
  final String? personalityHints;

  const PersonaHints({
    required this.name,
    this.targetSpeaker,
    this.relationship,
    this.userAlias,
    this.personalityHints,
  });
}

/// 人格提炼契约（手册 PERSONA-02）。
abstract class PersonaBuilder {
  /// 从已解析对话 + 用户设定提炼 L0–L5 画像（导入路径，§8.1）。
  Future<PersonaProfile> build(ParsedLog log, PersonaHints hints);

  /// 不导入聊天记录，直接按用户设定生成一份默认画像（直接创建路径）。
  /// 纯本地构造，不调用 LLM、不花 token。
  PersonaProfile buildFromHints(PersonaHints hints);
}
