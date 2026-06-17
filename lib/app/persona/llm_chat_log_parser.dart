import '../../domain/contracts/chat_log_parser.dart';
import '../../domain/contracts/model_adapter.dart';
import '../../domain/models/chat_message.dart';
import '../../prompts/persona_prompts.dart';
import 'json_extract.dart';
import 'local_chat_log_parser.dart';

/// 微信 txt 解析实现（手册 PERSONA-01 / 说明书 §7.4）。
///
/// 流程：**先本地结构化解析**（规整的「时间 '说话人'」格式直接全量切分，
/// 不花 token、不丢消息、不受 LLM 输出长度限制）；本地解析不出（杂乱文本/
/// 复制粘贴/OCR）才回退到 LLM，并对超长文本采样。LLM 也失败时兜底整段一条。
class LlmChatLogParser implements ChatLogParser {
  final ModelAdapter adapter;

  const LlmChatLogParser(this.adapter);

  @override
  Future<ParsedLog> parse(String rawText, {ParseOptions opts = const ParseOptions()}) async {
    final text = rawText.trim();
    if (text.isEmpty) {
      return const ParsedLog(messages: [], speakers: [], span: '');
    }

    // 1) 本地结构化解析优先：规整导出格式直接全量切分（处理上万条）。
    final local = LocalChatLogParser.tryParse(text);
    if (local != null) return local;

    // 2) 本地解析不出 → 回退 LLM。超长按行采样上限，取最近 maxLines 行。
    final lines = text.split(RegExp(r'\r?\n'));
    final sampled = lines.length > opts.maxLines;
    final usedText = sampled
        ? lines.sublist(lines.length - opts.maxLines).join('\n')
        : text;

    // 调 LLM 解析（system 固定，user 拼原文）。
    final buf = StringBuffer();
    await for (final chunk in adapter.chat(
      system: PersonaPrompts.parseSystem,
      messages: [Msg.user(PersonaPrompts.parseUser(usedText))],
      opts: const ChatOpts(temperature: 0.2), // 解析要稳，低温
    )) {
      buf.write(chunk);
    }

    final json = extractJsonObject(buf.toString());
    if (json == null) {
      // 兜底：解析不出结构，把（采样后的）原文当作单一说话人的一条。
      return ParsedLog(
        messages: [ParsedMessage(speaker: '未知', content: usedText)],
        speakers: const ['未知'],
        span: '',
        sampled: sampled,
        estimatedTotal: sampled ? lines.length : null,
      );
    }

    final msgs = (json['messages'] as List?)
            ?.whereType<Map>()
            .map((m) => ParsedMessage.fromJson(m.cast<String, dynamic>()))
            .toList() ??
        const <ParsedMessage>[];

    final speakers = (json['speakers'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
        // LLM 没给 speakers 时从消息里推。
        msgs.map((m) => m.speaker).toSet().toList();

    return ParsedLog(
      messages: msgs,
      speakers: speakers,
      span: (json['span'] ?? '').toString(),
      sampled: sampled,
      estimatedTotal: sampled ? lines.length : null,
    );
  }
}
