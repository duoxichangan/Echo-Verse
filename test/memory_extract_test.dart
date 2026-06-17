import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:virtual/adapter/mock_adapter.dart';
import 'package:virtual/app/memory/drift_memory_service.dart';
import 'package:virtual/data/db/database.dart';
import 'package:virtual/domain/models/chat_message.dart';
import 'package:virtual/domain/models/memory_extraction.dart';

bool _sqliteAvailable() {
  try {
    sqlite3.openInMemory().dispose();
    return true;
  } catch (_) {
    return false;
  }
}

const _now = 1700000000000;

void main() {
  // MemoryExtraction 模型解析（纯模型，无需 DB）。
  group('MemoryExtraction 解析', () {
    test('完整 JSON 解析', () {
      final ex = MemoryExtraction.fromJson({
        'summary_update': '聊了周末计划',
        'new_facts': [
          {'content': '用户喜欢爬山', 'importance': 0.8},
          {'content': '', 'importance': 0.5}, // 空内容应被过滤
        ],
        'superseded': [
          {'old_fact_id': 5, 'reason': '换工作了'},
          {'old_fact_id': 0}, // id<=0 过滤
        ],
        'relationship_update': {
          'mood': '开心',
          'closeness_delta': 0.1,
          'unresolved': ['周五要一起吃饭'],
        },
        'new_open_loops': [
          {
            'event': '用户下周面试',
            'planned_action': '问面试结果',
            'trigger_type': 'event',
            'importance': 0.9
          },
        ],
      });
      expect(ex.summaryUpdate, '聊了周末计划');
      expect(ex.newFacts.length, 1); // 空内容被过滤
      expect(ex.newFacts.first.content, '用户喜欢爬山');
      expect(ex.superseded.length, 1); // id<=0 被过滤
      expect(ex.superseded.first.oldFactId, 5);
      expect(ex.relationshipUpdate?.mood, '开心');
      expect(ex.relationshipUpdate?.closenessDelta, closeTo(0.1, 1e-9));
      expect(ex.newOpenLoops.length, 1);
    });

    test('钟点型 trigger_at 解析为毫秒', () {
      final l = ExtractedOpenLoop.fromJson({
        'event': '今晚汇报',
        'planned_action': '问结果',
        'trigger_type': 'clock',
        'trigger_at': '2026-06-17T20:30:00',
      });
      expect(l.triggerAtMs(), isNotNull);
    });

    test('空 JSON 全默认', () {
      final ex = MemoryExtraction.fromJson({});
      expect(ex.newFacts, isEmpty);
      expect(ex.superseded, isEmpty);
      expect(ex.relationshipUpdate, isNull);
      expect(ex.newOpenLoops, isEmpty);
    });
  });

  final hasSqlite = _sqliteAvailable();

  group('DriftMemoryService.extract (MEM-02)', () {
    late AppDatabase db;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      await db.into(db.personas).insert(PersonasCompanion.insert(
            name: '小桃',
            personaJson: '{}',
            personaJsonInitial: '{}',
            createdAt: _now,
            updatedAt: _now,
          ));
    });
    tearDown(() async => db.close());

    DriftMemoryService svc(String script) => DriftMemoryService(
          db,
          adapter: MockAdapter(script: script, chunkDelay: Duration.zero),
          nowMs: () => _now,
        );

    test('[记住:x] 内联标记直接入库（无需 LLM）', () async {
      // 无 adapter：只处理内联标记。
      final s = DriftMemoryService(db, nowMs: () => _now);
      await s.extract(1, [
        Msg.user('对了 [记住:我下周一搬家] 别忘了'),
        Msg.assistant('好嘞[记住:用户要搬家]'),
      ]);
      final facts = await db.select(db.facts).get();
      final contents = facts.map((f) => f.content).toList();
      expect(contents, contains('我下周一搬家'));
      expect(contents, contains('用户要搬家'));
      expect(facts.every((f) => f.importance >= 0.8), isTrue);
    });

    test('提炼新事实入库', () async {
      final s = svc(
          '{"new_facts":[{"content":"用户养了猫叫团子","importance":0.7}],"summary_update":"聊了宠物"}');
      await s.extract(1, [Msg.user('我家猫叫团子')]);

      final facts = await db.select(db.facts).get();
      expect(facts.any((f) => f.content == '用户养了猫叫团子'), isTrue);
      // L1 摘要更新
      final sum = await (db.select(db.sessionSummaries)
            ..where((t) => t.personaId.equals(1)))
          .getSingleOrNull();
      expect(sum?.summary, '聊了宠物');
    });

    test('矛盾覆盖：旧事实置 valid=false', () async {
      // 先放一条旧事实（id=1）。
      await db.into(db.facts).insert(FactsCompanion.insert(
            personaId: 1,
            content: '用户在读大学',
            lastReferencedAt: _now,
            createdAt: _now,
            importance: const Value(0.7),
          ));
      final s = svc(
          '{"new_facts":[{"content":"用户已工作","importance":0.8}],"superseded":[{"old_fact_id":1,"reason":"毕业了"}]}');
      await s.extract(1, [Msg.user('我毕业上班了')]);

      final old = await (db.select(db.facts)..where((f) => f.id.equals(1)))
          .getSingle();
      expect(old.valid, isFalse);
      expect(old.supersededBy, isNotNull);
      // 新事实在库且有效
      final facts = await db.select(db.facts).get();
      expect(facts.any((f) => f.content == '用户已工作' && f.valid), isTrue);
    });

    test('更新 L3 关系（closeness 增量 + clamp）', () async {
      final s = svc(
          '{"relationship_update":{"mood":"想念","closeness_delta":0.6,"unresolved":["还没回他消息"]}}');
      await s.extract(1, [Msg.user('好久没聊了')]);

      final rel = await (db.select(db.relationshipStates)
            ..where((t) => t.personaId.equals(1)))
          .getSingle();
      expect(rel.mood, '想念');
      // 默认 0.5 + 0.6 = 1.1 → clamp 到 1.0
      expect(rel.closeness, 1.0);
      expect(rel.unresolved, contains('还没回他消息'));
    });

    test('开放回路落库为 pending（本轮不调度）', () async {
      final s = svc(
          '{"new_open_loops":[{"event":"用户明早面试","planned_action":"问面试咋样","trigger_type":"clock","trigger_at":"2026-06-18T09:00:00","importance":0.9}]}');
      await s.extract(1, [Msg.user('明早有个面试好紧张')]);

      final loops = await db.select(db.openLoops).get();
      expect(loops.length, 1);
      expect(loops.first.event, '用户明早面试');
      expect(loops.first.status, 'pending');
      expect(loops.first.triggerAt, isNotNull);
    });

    test('LLM 返回非 JSON 时不动库（内联标记仍生效）', () async {
      final s = svc('抱歉我不会');
      await s.extract(1, [Msg.user('随便聊聊 [记住:今天很开心]')]);
      final facts = await db.select(db.facts).get();
      // 内联标记仍入库，LLM 部分无产出。
      expect(facts.length, 1);
      expect(facts.first.content, '今天很开心');
    });
  },
      skip: hasSqlite
          ? false
          : '宿主缺少 native sqlite3 库（VM 测试环境），改在真机/集成测试运行');
}
