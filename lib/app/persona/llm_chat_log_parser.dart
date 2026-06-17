import '../../domain/contracts/chat_log_parser.dart';
import '../../domain/contracts/model_adapter.dart';
import '../../domain/models/chat_message.dart';
import '../../prompts/persona_prompts.dart';
import 'json_extract.dart';

/// 微信 txt 解析实现（手册 PERSONA-01 / 说明书 §7.4）。
///
/// 流程：采样上限裁剪 → 全交 LLM 解析为结构化 JSON → 转 [ParsedLog]。
/// 解析失败兜底为“整段当一条”，保证建号不中断。
class LlmChatLogParser implements ChatLogParser {
  final ModelAdapter adapter;

  const LlmChatLogParser(this.adapter);

  @override
  Future<ParsedLog> parse(String rawText, {ParseOptions opts = const ParseOptions()}) async {
    final text = rawText.trim();
    if (text.isEmpty) {
      return const ParsedLog(messages: [], speakers: [], span: '');
    }

    // 采样上限（§7.4）：按行数裁，取最近 maxLines 行。
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
