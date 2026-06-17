import 'dart:math' as math;

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:virtual/app/memory/drift_memory_service.dart';
import 'package:virtual/app/memory/salience.dart';
import 'package:virtual/data/db/database.dart';
import 'package:virtual/domain/models/chat_message.dart';

bool _sqliteAvailable() {
  try {
    sqlite3.openInMemory().dispose();
    return true;
  } catch (_) {
    return false;
  }
}

const _day = 86400000; // 一天毫秒
const _now = 1000000000000; // 固定“现在”，避免依赖真实时钟

void main() {
  // ── Salience 纯函数（无需 DB）─────────────────────────────
  group('Salience 显著度评分', () {
    test('刚提起（Δt=0）显著度 = importance', () {
      expect(
        Salience.score(importance: 0.8, lastReferencedAtMs: _now, nowMs: _now),
        closeTo(0.8, 1e-9),
      );
    });

    test('过一个半衰期后衰减到约一半', () {
      final s = Salience.score(
        importance: 1.0,
        lastReferencedAtMs: _now - 14 * _day,
        nowMs: _now,
        halfLife: const Duration(days: 14),
      );
      expect(s, closeTo(0.5, 1e-6));
    });

    test('pinned 跳过衰减，恒为 importance', () {
      final s = Salience.score(
        importance: 0.6,
        lastReferencedAtMs: _now - 365 * _day,
        nowMs: _now,
        pinned: true,
      );
      expect(s, 0.6);
    });

    test('越重要衰减后仍越高（同样时间间隔）', () {
      double at(double imp) => Salience.score(
            importance: imp,
            lastReferencedAtMs: _now - 30 * _day,
            nowMs: _now,
          );
      expect(at(0.9), greaterThan(at(0.3)));
    });

    test('未来时间戳（Δt<0）视为刚提起，不衰减', () {
      final s = Salience.score(
        importance: 0.5,
        lastReferencedAtMs: _now + 10 * _day,
        nowMs: _now,
      );
      expect(s, 0.5);
    });

    test('衰减单调递减', () {
      double at(int days) => Salience.score(
            importance: 1.0,
            lastReferencedAtMs: _now - days * _day,
            nowMs: _now,
          );
      expect(at(1), greaterThan(at(7)));
      expect(at(7), greaterThan(at(30)));
      expect(at(30), greaterThan(at(100)));
      // 始终为正、不超过 importance
      expect(at(100), greaterThan(0));
      expect(at(0), lessThanOrEqualTo(1.0 + 1e-9));
      expect(math.exp(0), 1); // sanity
    });
  });

  // ── DriftMemoryService（需 native sqlite）──────────────────
  final hasSqlite = _sqliteAvailable();

  group('DriftMemoryService', () {
    late AppDatabase db;
    late DriftMemoryService mem;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      mem = DriftMemoryService(db, nowMs: () => _now);
      // 一个人格
      await db.into(db.personas).insert(PersonasCompanion.insert(
            name: '团子',
            personaJson: '{}',
            personaJsonInitial: '{}',
            createdAt: _now,
            updatedAt: _now,
          ));
    });

    tearDown(() async => db.close());

    Future<int> addFact(
      String content, {
      double importance = 0.5,
      int? lastRef,
      bool pinned = false,
      bool valid = true,
      int? supersededBy,
    }) {
      return db.into(db.facts).insert(FactsCompanion.insert(
            personaId: 1,
            content: content,
            lastReferencedAt: lastRef ?? _now,
            createdAt: _now,
            importance: Value(importance),
            pinned: Value(pinned),
            valid: Value(valid),
            supersededBy:
                supersededBy == null ? const Value.absent() : Value(supersededBy),
          ));
    }

    Future<void> addMsg(String content, {String sender = 'user', int? at}) {
      return db.into(db.messages).insert(MessagesCompanion.insert(
            personaId: 1,
            sender: sender,
            content: content,
            createdAt: at ?? _now,
          ));
    }

    test('readResident 拼装摘要 + 关系 + 高显著事实', () async {
      await db.into(db.sessionSummaries).insert(SessionSummariesCompanion.insert(
            personaId: const Value(1),
            summary: const Value('今天聊了周末出去玩'),
            updatedAt: _now,
          ));
      await db.into(db.relationshipStates).insert(
          RelationshipStatesCompanion.insert(
              personaId: const Value(1),
              mood: const Value('开心'),
              updatedAt: _now));
      await addFact('用户的猫叫团子', importance: 0.9);

      final text = await mem.readResident(1, 4000);
      expect(text, contains('周末出去玩'));
      expect(text, contains('开心'));
      expect(text, contains('用户的猫叫团子'));
    });

    test('topFacts 过滤无效/被覆盖，pinned 置顶，按显著度排序', () async {
      await addFact('低分旧事实', importance: 0.2, lastRef: _now - 60 * _day);
      await addFact('高分新事实', importance: 0.9, lastRef: _now);
      await addFact('被覆盖的', importance: 0.9, supersededBy: 1);
      await addFact('无效的', importance: 0.9, valid: false);
      await addFact('置顶但低分', importance: 0.1, pinned: true);

      final facts = await mem.topFacts(1);
      final contents = facts.map((f) => f.content).toList();

      expect(contents, contains('高分新事实'));
      expect(contents, contains('低分旧事实'));
      expect(contents, isNot(contains('被覆盖的')));
      expect(contents, isNot(contains('无效的')));
      // pinned 排第一
      expect(contents.first, '置顶但低分');
      // 高分排在低分旧事实之前
      expect(contents.indexOf('高分新事实'),
          lessThan(contents.indexOf('低分旧事实')));
    });

    test('readResident 受预算约束，预算极小只保留高优先段', () async {
      await db.into(db.sessionSummaries).insert(SessionSummariesCompanion.insert(
            personaId: const Value(1),
            summary: const Value('简短摘要'),
            updatedAt: _now,
          ));
      await addFact('一条不该被带进来的很长很长很长很长的事实内容', importance: 0.9);

      // 预算只够摘要段（含标题“【最近聊了什么】”共约 12 字），放不下长事实段。
      final text = await mem.readResident(1, 15);
      expect(text, contains('简短摘要'));
      expect(text, isNot(contains('很长很长')));
    });

    test('search 按命中词数 + 新近排序，去重', () async {
      await addFact('用户养了一只猫叫团子', importance: 0.8);
      await addMsg('团子今天又拆家了', at: _now - 2 * _day);
      await addMsg('我们去吃了火锅', at: _now);

      final hits = await mem.search(1, '团子 猫');
      expect(hits, isNotEmpty);
      // “用户养了一只猫叫团子”命中“团子”和“猫”两词，应排第一
      expect(hits.first, contains('团子'));
      expect(hits.first, contains('猫'));
      // 无关消息不应命中
      expect(hits.any((h) => h.contains('火锅')), isFalse);
    });

    test('search 无命中返回空；空查询返回空', () async {
      await addFact('用户喜欢爬山', importance: 0.5);
      expect(await mem.search(1, '完全不相关的词'), isEmpty);
      expect(await mem.search(1, '   '), isEmpty);
    });

    test('extract 已实现：无 adapter 时只处理 [记住:x]，不抛', () async {
      // 这里的 mem 未注入 adapter，extract 应跳过 LLM 提炼、只抓内联标记。
      await mem.extract(1, [Msg.user('记得 [记住:周末去爬山]')]);
      final facts = await db.select(db.facts).get();
      expect(facts.any((f) => f.content == '周末去爬山'), isTrue);
    });

    test('MEM-04 listFacts 返回带显著度的事实', () async {
      await addFact('高分', importance: 0.9);
      await addFact('低分旧', importance: 0.2, lastRef: _now - 60 * _day);
      final list = await mem.listFacts(1);
      expect(list.length, 2);
      // 已含显著度，高分在前
      expect(list.first.content, '高分');
      expect(list.first.salience, greaterThan(list.last.salience));
    });

    test('MEM-04 置顶/改/删', () async {
      final id = await addFact('原始内容', importance: 0.5);

      await mem.setFactPinned(id, true);
      var list = await mem.listFacts(1);
      expect(list.first.pinned, isTrue);

      await mem.updateFactContent(id, '改后内容');
      list = await mem.listFacts(1);
      expect(list.first.content, '改后内容');

      await mem.deleteFact(id);
      list = await mem.listFacts(1);
      expect(list, isEmpty);
    });
  },
      skip: hasSqlite
          ? false
          : '宿主缺少 native sqlite3 库（VM 测试环境），改在真机/集成测试运行');
}
