import '../../domain/contracts/chat_log_parser.dart';

/// 本地结构化解析器：处理「时间 '说话人'」开头的规整导出格式（最常见）。
///
/// 形如：
/// ```
/// 2025-01-12 12:57:01 '我'
/// 家娃大作业！
///
/// 2025-01-12 13:07:46 '周菲阳'
/// [表情包]
/// ```
/// 这类文件不需要 LLM——本地正则即可 100% 精确切分上万条，不花 token、不丢消息。
/// 解析不出（格式不规整/复制粘贴/OCR）则返回 null，由调用方回退 LLM。
class LocalChatLogParser {
  /// 匹配消息头：日期 时间 + 引号包裹的说话人。引号支持中英文单双引号，也允许无引号。
  /// 例：`2025-01-12 12:57:01 '我'`、`2025/1/2 9:8:7 "张三"`、`2025-01-02 09:08:07 张三`
  static final _headExp = RegExp(
    r'''^(\d{4}[-/]\d{1,2}[-/]\d{1,2}\s+\d{1,2}:\d{1,2}:\d{1,2})\s+['‘“"]?(.+?)['’”"]?\s*$''',
  );

  /// 非文本占位符 → type 映射。
  static const _placeholders = <String, String>{
    '[图片]': 'image',
    '[表情包]': 'sticker',
    '[表情]': 'sticker',
    '[语音]': 'voice',
    '[视频]': 'video',
    '[红包]': 'redpacket',
    '[转账]': 'redpacket',
    '[位置]': 'location',
    '[文件]': 'file',
    '[链接]': 'link',
    '[撤回了一条消息]': 'recall',
    '[聊天记录]': 'merged',
  };

  /// 尝试本地解析。命中（识别出足够多结构化消息）返回 [ParsedLog]，否则 null。
  static ParsedLog? tryParse(String rawText) {
    final lines = rawText.split(RegExp(r'\r?\n'));

    final messages = <ParsedMessage>[];
    final speakerCount = <String, int>{};

    String? curSpeaker;
    String? curTime;
    final curContent = <String>[];

    void flush() {
      final speaker = curSpeaker;
      if (speaker == null) return;
      final content = curContent.join('\n').trim();
      messages.add(ParsedMessage(
        speaker: speaker,
        content: content,
        time: curTime ?? '',
        type: _typeOf(content),
      ));
      speakerCount[speaker] = (speakerCount[speaker] ?? 0) + 1;
    }

    for (final raw in lines) {
      final line = raw.trimRight();
      final m = _headExp.firstMatch(line.trim());
      if (m != null) {
        // 遇到新消息头：先收上一条。
        flush();
        curTime = m.group(1);
        curSpeaker = m.group(2)!.trim();
        curContent.clear();
      } else if (curSpeaker != null) {
        // 头之后的内容行（空行也保留为内容内换行，但前导空行忽略）。
        if (line.trim().isEmpty && curContent.isEmpty) continue;
        curContent.add(line);
      }
      // 还没遇到任何头行的前导杂行：忽略。
    }
    flush();

    // 判定本地解析成功：至少 2 条结构化消息（杂乱文本切不出，会回退 LLM）。
    if (messages.length < 2) return null;

    final span = _span(messages);
    return ParsedLog(
      messages: messages,
      speakers: speakerCount.keys.toList(),
      span: span,
      sampled: false,
    );
  }

  static String _typeOf(String content) {
    final t = content.trim();
    final mapped = _placeholders[t];
    if (mapped != null) return mapped;
    return 'text';
  }

  static String _span(List<ParsedMessage> msgs) {
    final times = msgs.map((m) => m.time).where((t) => t.isNotEmpty).toList();
    if (times.isEmpty) return '';
    if (times.length == 1) return times.first;
    return '${times.first} 至 ${times.last}';
  }
}
