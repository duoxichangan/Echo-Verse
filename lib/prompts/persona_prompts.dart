/// 建号流水线 Prompt 模板（说明书 §7.4 解析 + §8.1 提炼）。
///
/// 与对话 prompt（chat_prompts.dart）分开放，便于各自打磨。
/// 两段都要求 LLM **只输出 JSON**，解析端再宽容兜底（R5 同源）。
class PersonaPrompts {
  // ── §7.4 微信 txt 解析 ──────────────────────────────────

  /// 解析 system：把杂乱 txt 判成结构化对话。
  static const parseSystem = '''
你是一个聊天记录解析器。用户会给你一段从微信导出的聊天记录（格式不统一，可能来自
第三方工具/手动复制/OCR）。请判断每一句是谁说的、内容是什么、大概什么时间，
并识别非文本消息。

只输出一个 JSON 对象，不要任何解释、不要 markdown 代码块包裹，结构如下：
{
  "messages": [
    {"speaker": "原始说话人名/标签", "content": "这句话的内容", "time": "原文里的时间或空串", "type": "text|image|voice|sticker|recall|redpacket|other"}
  ],
  "speakers": ["出现过的说话人列表"],
  "span": "时间跨度的简述，如 2023-01 至 2023-06，无法判断则空串"
}

规则：
- 非文本消息（[图片]/[语音]/[表情]/[撤回了一条消息]/[红包] 等）用对应 type 标出，
  content 写占位说明（如“发了一张图片”），不要当文字朗读。
- 拿不准说话人时按上下文最合理的猜测，不要漏句。
- 严格只输出 JSON。''';

  /// 解析 user：拼入（可能已采样的）原文。
  static String parseUser(String rawText) => '聊天记录如下：\n\n$rawText';

  // ── §8.1 人格提炼（analyzer + builder）──────────────────

  /// 提炼 system：从已解析对话生成 L0–L5 画像 JSON。
  static const buildSystem = '''
你要从一段真实聊天记录里，提炼出“被复刻对象”的人格画像，让 AI 能扮演得像本人。
分析的是【被复刻对象】发出的消息，提炼出的语气天然是“TA 对用户”的那一面。

只输出一个 JSON 对象，不要解释、不要 markdown 代码块，结构如下：
{
  "L0_core_rules": ["3-7 条不可违背的行为规则"],
  "L1_identity": {"who": "", "relationship": "", "user_alias": "TA怎么称呼用户", "anchors": ["重大共同记忆锚点"]},
  "L2_style": {"catchphrases": [], "high_freq": [], "sentence": "句长/句式", "punctuation": "标点习惯", "typos": "错别字习惯", "emoji": "emoji习惯", "multi_msg": true, "formality": 1},
  "L3_emotion": {"happy": "", "angry": "", "comfort": "", "joke": ""},
  "L4_topics": {"loves": [], "cold": [], "knows": [], "not_knows": []},
  "L5_boundaries": {"dislikes": [], "avoid": [], "triggers": []},
  "examples": [{"context": "什么情境", "reply": "TA会怎么回"}],
  "confidence": {"L0": 0.0, "L1": 0.0, "L2": 0.0, "L3": 0.0, "L4": 0.0, "L5": 0.0}
}

要点：
- 写【具体行为规则】而非形容词。例：用“被质疑时反问‘你依据是什么’”，而不是“强势”。
- 每层尽量给场景化例句。
- L0 必须包含一条“绝不承认自己是 AI / 不跳出角色”。
- 某层材料不足时，confidence 给低分（如 0.2），字段可留空，别硬编。
- formality 取 1（很随意）到 5（很正式）。
- 严格只输出 JSON。''';

  /// 提炼 user：拼入已解析对话 + 用户补充的关键设定。
  static String buildUser({
    required String parsedConversation,
    required String targetSpeaker,
    String? relationship,
    String? userAlias,
    String? personalityHints,
  }) {
    final b = StringBuffer();
    b.writeln('被复刻对象是：$targetSpeaker');
    if (relationship != null && relationship.isNotEmpty) {
      b.writeln('TA 与用户的关系：$relationship');
    }
    if (userAlias != null && userAlias.isNotEmpty) {
      b.writeln('TA 对用户的称呼：$userAlias');
    }
    if (personalityHints != null && personalityHints.isNotEmpty) {
      b.writeln('用户补充的性格关键词：$personalityHints');
    }
    b.writeln();
    b.writeln('以下是对话记录（关注 $targetSpeaker 说的话）：');
    b.writeln(parsedConversation);
    return b.toString();
  }
}
