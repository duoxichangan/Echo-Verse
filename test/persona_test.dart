import 'package:flutter_test/flutter_test.dart';
import 'package:virtual/adapter/mock_adapter.dart';
import 'package:virtual/app/persona/json_extract.dart';
import 'package:virtual/app/persona/llm_chat_log_parser.dart';
import 'package:virtual/app/persona/llm_persona_builder.dart';
import 'package:virtual/domain/contracts/chat_log_parser.dart';
import 'package:virtual/domain/contracts/persona_builder.dart';
import 'package:virtual/domain/models/persona_profile.dart';

void main() {
  group('extractJsonObject', () {
    test('裸 JSON', () {
      expect(extractJsonObject('{"a":1}')?['a'], 1);
    });
    test('剥 ```json 代码块', () {
      final j = extractJsonObject('好的：\n```json\n{"a":2}\n```\n');
      expect(j?['a'], 2);
    });
    test('前后带解释文字，取 {..}', () {
      final j = extractJsonObject('这是结果 {"a":3} 完毕');
      expect(j?['a'], 3);
    });
    test('解析不出返回 null', () {
      expect(extractJsonObject('完全不是 json'), isNull);
    });
  });

  group('PersonaProfile 编解码', () {
    test('empty 含 L0 不承认 AI 铁律', () {
      final p = PersonaProfile.empty();
      expect(p.coreRules, isNotEmpty);
      expect(p.coreRules.any((r) => r.contains('AI')), isTrue);
    });

    test('toJson → fromJson 往返保真', () {
      const p = PersonaProfile(
        coreRules: ['绝不承认是 AI', '永远叫笨蛋'],
        identity: PersonaIdentity(
            who: '小桃', relationship: '女友', userAlias: '笨蛋', anchors: ['一起爬过山']),
        style: PersonaStyle(catchphrases: ['哼'], multiMsg: true, formality: 1),
        topics: PersonaTopics(loves: ['奶茶']),
        confidence: {'L0': 1.0, 'L2': 0.3},
      );
      final back = PersonaProfile.fromJson(p.toJson());
      expect(back.coreRules, p.coreRules);
      expect(back.identity.who, '小桃');
      expect(back.identity.anchors, ['一起爬过山']);
      expect(back.style.catchphrases, ['哼']);
      expect(back.style.formality, 1);
      expect(back.topics.loves, ['奶茶']);
      expect(back.confidence['L2'], 0.3);
    });

    test('fromJsonString 坏输入回退空骨架', () {
      final p = PersonaProfile.fromJsonString('不是 json');
      expect(p.coreRules.any((r) => r.contains('AI')), isTrue);
    });

    test('缺字段宽容解析不抛', () {
      final p = PersonaProfile.fromJson({'L0_core_rules': ['只有这条']});
      expect(p.coreRules, ['只有这条']);
      expect(p.identity.who, '');
      expect(p.style.multiMsg, true); // 默认值
    });
  });

  group('LlmChatLogParser (PERSONA-01)', () {
    test('解析 LLM 返回的结构化 JSON', () async {
      const script = '''
{"messages":[
  {"speaker":"小桃","content":"在吗","time":"2023-01-01 20:00","type":"text"},
  {"speaker":"我","content":"在的","time":"","type":"text"},
  {"speaker":"小桃","content":"发了一张图片","time":"","type":"image"}
],"speakers":["小桃","我"],"span":"2023-01"}''';
      final parser =
          LlmChatLogParser(const MockAdapter(script: script, chunkDelay: Duration.zero));
      final log = await parser.parse('随便什么原文');

      expect(log.messages.length, 3);
      expect(log.speakers, containsAll(['小桃', '我']));
      expect(log.span, '2023-01');
      expect(log.messages[2].type, 'image'); // 非文本占位识别
      expect(log.sampled, isFalse);
    });

    test('超过采样上限时标记 sampled', () async {
      final manyLines = List.generate(50, (i) => '小桃: 第 $i 句').join('\n');
      const script = '{"messages":[],"speakers":[],"span":""}';
      final parser =
          LlmChatLogParser(const MockAdapter(script: script, chunkDelay: Duration.zero));
      final log = await parser.parse(manyLines, opts: const ParseOptions(maxLines: 10));

      expect(log.sampled, isTrue);
      expect(log.estimatedTotal, 50);
    });

    test('LLM 返回非 JSON 时兜底为整段一条', () async {
      final parser = LlmChatLogParser(
          const MockAdapter(script: '抱歉我不会', chunkDelay: Duration.zero));
      final log = await parser.parse('一些聊天原文');
      expect(log.messages.length, 1);
      expect(log.messages.first.content, contains('一些聊天原文'));
    });

    test('空原文返回空', () async {
      final parser =
          LlmChatLogParser(const MockAdapter(script: '{}', chunkDelay: Duration.zero));
      final log = await parser.parse('   ');
      expect(log.messages, isEmpty);
    });
  });

  group('LlmPersonaBuilder (PERSONA-02)', () {
    test('build 从对话提炼画像，并保证 L0 含不承认 AI', () async {
      const script = '''
{"L0_core_rules":["永远叫笨蛋"],
 "L1_identity":{"who":"小桃","relationship":"女友","user_alias":"笨蛋"},
 "L2_style":{"catchphrases":["哼"],"multi_msg":true,"formality":1},
 "L4_topics":{"loves":["奶茶"]},
 "confidence":{"L0":0.9,"L2":0.7}}''';
      final builder =
          LlmPersonaBuilder(const MockAdapter(script: script, chunkDelay: Duration.zero));
      const log = ParsedLog(messages: [
        ParsedMessage(speaker: '小桃', content: '笨蛋在干嘛'),
      ], speakers: ['小桃']);

      final p = await builder.build(
          log, const PersonaHints(name: '小桃', targetSpeaker: '小桃'));

      // 模型只给了“永远叫笨蛋”，_ensureCoreRules 应补上不承认 AI。
      expect(p.coreRules.any((r) => r.contains('AI')), isTrue);
      expect(p.coreRules, contains('永远叫笨蛋'));
      expect(p.identity.who, '小桃');
      expect(p.style.catchphrases, ['哼']);
      expect(p.topics.loves, ['奶茶']);
    });

    test('build 失败（非 JSON）回退到 buildFromHints', () async {
      final builder =
          LlmPersonaBuilder(const MockAdapter(script: '不会', chunkDelay: Duration.zero));
      const log = ParsedLog(messages: [], speakers: []);
      final p = await builder.build(
          log, const PersonaHints(name: '阿强', relationship: '哥们'));
      expect(p.identity.who, '阿强');
      expect(p.identity.relationship, '哥们');
      expect(p.coreRules.any((r) => r.contains('AI')), isTrue);
    });

    test('buildFromHints 不调 LLM，按设定造默认画像', () {
      // 故意给一个会抛的 adapter，证明 buildFromHints 根本不碰它。
      final builder = LlmPersonaBuilder(const MockAdapter(script: 'X'));
      final p = builder.buildFromHints(const PersonaHints(
        name: '小美',
        relationship: '同事',
        userAlias: '老板',
        personalityHints: '开朗、爱笑、毒舌',
      ));
      expect(p.identity.who, '小美');
      expect(p.identity.relationship, '同事');
      expect(p.identity.userAlias, '老板');
      // 性格关键词进了 L2 高频词，置信度标低。
      expect(p.style.highFreq, containsAll(['开朗', '爱笑', '毒舌']));
      expect(p.confidence['L2'], lessThan(0.5));
      expect(p.coreRules.any((r) => r.contains('AI')), isTrue);
    });

    test('用户硬设定覆盖模型猜测的 L1', () async {
      // 模型说关系是“网友”，但用户填了“女友”，应以用户为准。
      const script =
          '{"L1_identity":{"who":"小桃","relationship":"网友"},"L0_core_rules":["绝不承认是AI"]}';
      final builder =
          LlmPersonaBuilder(const MockAdapter(script: script, chunkDelay: Duration.zero));
      const log = ParsedLog(messages: [], speakers: ['小桃']);
      final p = await builder.build(log,
          const PersonaHints(name: '小桃', relationship: '女友', userAlias: '笨蛋'));
      expect(p.identity.relationship, '女友');
      expect(p.identity.userAlias, '笨蛋');
    });
  });
}
