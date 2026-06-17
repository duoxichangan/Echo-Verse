import 'package:flutter_test/flutter_test.dart';
import 'package:virtual/adapter/mock_adapter.dart';
import 'package:virtual/app/persona/llm_chat_log_parser.dart';
import 'package:virtual/app/persona/local_chat_log_parser.dart';
import 'package:virtual/domain/contracts/chat_log_parser.dart';
import 'package:virtual/domain/contracts/persona_builder.dart';
import 'package:virtual/app/persona/llm_persona_builder.dart';

/// 模拟用户真实文件格式：`时间 '说话人'` 头 + 内容行 + 空行分隔。
const _real = '''
2025-01-12 12:57:01 '我'
家娃大作业！

2025-01-12 13:07:46 '周菲阳'
[表情包]

2025-01-12 13:07:52 '周菲阳'
我和我爸妈吵架了

2025-01-12 13:08:00 '我'
咋啦咋啦

2025-01-12 13:08:10 '周菲阳'
他们老是催我

2025-01-12 13:08:20 '我'
[图片]
''';

void main() {
  group('LocalChatLogParser（本地结构化解析）', () {
    test('真实格式：切出全部消息、说话人、占位符', () {
      final log = LocalChatLogParser.tryParse(_real);
      expect(log, isNotNull);
      expect(log!.messages.length, 6);
      expect(log.speakers.toSet(), {'我', '周菲阳'});
      // 占位符识别
      expect(log.messages[1].type, 'sticker'); // [表情包]
      expect(log.messages.last.type, 'image'); // [图片]
      // 文本内容
      expect(log.messages[0].content, '家娃大作业！');
      expect(log.messages[2].content, '我和我爸妈吵架了');
      // 时间与跨度
      expect(log.messages[0].time, '2025-01-12 12:57:01');
      expect(log.span, contains('至'));
      expect(log.sampled, isFalse);
    });

    test('多行内容合并为一条', () {
      const txt = '''
2025-01-01 10:00:00 '张三'
第一行
第二行
第三行

2025-01-01 10:00:05 '李四'
好的
''';
      final log = LocalChatLogParser.tryParse(txt);
      expect(log, isNotNull);
      expect(log!.messages.length, 2);
      expect(log.messages[0].content, '第一行\n第二行\n第三行');
    });

    test('杂乱文本（无规整头）返回 null', () {
      const messy = '今天天气不错\n我们去吃饭吧\n好啊好啊\n几点';
      expect(LocalChatLogParser.tryParse(messy), isNull);
    });

    test('双引号说话人也能解析', () {
      const txt = '''
2025-01-01 10:00:00 "Alice"
hello

2025-01-01 10:00:05 "Bob"
hi
''';
      final log = LocalChatLogParser.tryParse(txt);
      expect(log, isNotNull);
      expect(log!.speakers.toSet(), {'Alice', 'Bob'});
    });
  });

  group('LlmChatLogParser（本地优先）', () {
    test('规整格式走本地解析，不调 LLM', () async {
      // 给一个会抛错的 adapter——若被调用就会炸，证明本地解析根本没碰它。
      final parser = LlmChatLogParser(const MockAdapter(script: 'X'));
      final log = await parser.parse(_real);
      expect(log.messages.length, 6); // 本地全量切出，不受 LLM 影响
      expect(log.sampled, isFalse);
    });

    test('杂乱文本回退 LLM 解析', () async {
      const script =
          '{"messages":[{"speaker":"A","content":"hi","type":"text"}],"speakers":["A"],"span":""}';
      final parser =
          LlmChatLogParser(const MockAdapter(script: script, chunkDelay: Duration.zero));
      final log = await parser.parse('随便一段没格式的复制粘贴文本，断断续续');
      expect(log.messages.length, 1);
      expect(log.messages.first.speaker, 'A');
    });
  });

  group('LlmPersonaBuilder map-reduce（多轮凝练）', () {
    test('超过批大小时分批，最后汇总，progress 回调到达 total', () async {
      // 造 7 条消息，batchSize=3 → 3 批 + 1 reduce = 4 步。
      final msgs = List.generate(
          7,
          (i) => ParsedMessage(
              speaker: i.isEven ? '我' : 'TA', content: '第 $i 句', type: 'text'));
      final log = ParsedLog(messages: msgs, speakers: const ['我', 'TA']);

      // map 阶段返回观察笔记（纯文本），reduce 阶段返回画像 JSON。
      final builder = LlmPersonaBuilder(
        MockAdapter(
          chunkDelay: Duration.zero,
          scriptFor: (m) {
            final isReduce = m.last.content.contains('观察笔记汇总');
            return isReduce
                ? '{"L0_core_rules":["绝不承认是AI"],"L2_style":{"catchphrases":["哈"]}}'
                : '观察：爱用语气词';
          },
        ),
        batchSize: 3,
      );

      final progress = <String>[];
      final profile = await builder.build(
        log,
        const PersonaHints(name: 'TA', targetSpeaker: 'TA'),
        onProgress: (d, t) => progress.add('$d/$t'),
      );

      expect(profile.coreRules.any((r) => r.contains('AI')), isTrue);
      expect(profile.style.catchphrases, ['哈']);
      // 4 步（3 map + 1 reduce），最后一步到达 total
      expect(progress.last, '4/4');
    });

    test('短记录单批直接提炼', () async {
      final log = ParsedLog(messages: const [
        ParsedMessage(speaker: 'TA', content: '在吗', type: 'text'),
      ], speakers: const ['TA']);
      final builder = LlmPersonaBuilder(
        const MockAdapter(
            script: '{"L0_core_rules":["绝不承认是AI"]}', chunkDelay: Duration.zero),
        batchSize: 300,
      );
      final p = await builder.build(log, const PersonaHints(name: 'TA'));
      expect(p.coreRules.any((r) => r.contains('AI')), isTrue);
    });
  });
}
