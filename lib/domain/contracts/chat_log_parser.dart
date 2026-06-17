// 微信 txt 解析的结果模型（手册 PERSONA-01）。

/// 解析出的一条消息。
class ParsedMessage {
  final String speaker; // 原始说话人名/标签
  final String content; // 内容（非文本为占位说明）
  final String time; // 原文时间或空串
  final String type; // text/image/voice/sticker/recall/redpacket/other

  const ParsedMessage({
    required this.speaker,
    required this.content,
    this.time = '',
    this.type = 'text',
  });

  factory ParsedMessage.fromJson(Map<String, dynamic> j) => ParsedMessage(
        speaker: (j['speaker'] ?? '').toString(),
        content: (j['content'] ?? '').toString(),
        time: (j['time'] ?? '').toString(),
        type: (j['type'] ?? 'text').toString(),
      );
}

/// 解析后的整段对话。
class ParsedLog {
  final List<ParsedMessage> messages;
  final List<String> speakers;
  final String span; // 时间跨度简述

  /// 是否触发了采样上限（原文过长，只分析了一部分）——供 UI 提示。
  final bool sampled;

  /// 原始总条数的估计（采样前），UI 提示用；无法估计为 null。
  final int? estimatedTotal;

  const ParsedLog({
    required this.messages,
    required this.speakers,
    this.span = '',
    this.sampled = false,
    this.estimatedTotal,
  });

  /// 把对话拼成可读文本，喂给提炼 prompt。
  String toConversationText() {
    final b = StringBuffer();
    for (final m in messages) {
      final t = m.time.isEmpty ? '' : '[${m.time}] ';
      b.writeln('$t${m.speaker}: ${m.content}');
    }
    return b.toString();
  }
}

/// 解析选项。
class ParseOptions {
  /// 采样上限：原文按行数超过此值时，只取最近 [maxLines] 行交给 LLM（§7.4）。
  final int maxLines;

  const ParseOptions({this.maxLines = 600});
}

/// 微信 txt 解析契约（手册 PERSONA-01）。
///
/// 全交 LLM 解析（说明书 §7.4）：最宽容、最省开发。LLM 依赖只经 ModelAdapter，
/// 可用 MockAdapter 返回固定 JSON 离线验证解析逻辑。
abstract class ChatLogParser {
  Future<ParsedLog> parse(String rawText, {ParseOptions opts});
}
