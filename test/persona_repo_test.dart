import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:virtual/data/db/database.dart';
import 'package:virtual/data/repos/drift_persona_repo.dart';

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
  final hasSqlite = _sqliteAvailable();

  group('DriftPersonaRepo.delete 级联删除', () {
    test('删人格时清掉其全部关联数据', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final repo = DriftPersonaRepo(db, nowMs: () => _now);

      final id = await repo.create(name: '小桃', personaJson: '{}');
      // 造各类关联数据。
      await db.into(db.messages).insert(MessagesCompanion.insert(
          personaId: id, sender: 'user', content: '在吗', createdAt: _now));
      await db.into(db.facts).insert(FactsCompanion.insert(
          personaId: id, content: '爱爬山', lastReferencedAt: _now, createdAt: _now));
      await db.into(db.relationshipStates).insert(RelationshipStatesCompanion.insert(
          personaId: Value(id), updatedAt: _now));
      await db.into(db.openLoops).insert(OpenLoopsCompanion.insert(
          personaId: id, event: 'e', plannedAction: 'a', triggerType: 'event', createdAt: _now));
      await db.into(db.stickers).insert(StickersCompanion.insert(
          filePath: '/s.png', label: '笑', createdAt: _now, personaId: Value(id)));
      await db.into(db.moments).insert(MomentsCompanion.insert(
          personaId: id, content: '今天好开心', postedAt: _now));

      await repo.delete(id);

      expect(await repo.getPersona(id), isNull);
      expect((await db.select(db.messages).get()), isEmpty);
      expect((await db.select(db.facts).get()), isEmpty);
      expect((await db.select(db.relationshipStates).get()), isEmpty);
      expect((await db.select(db.openLoops).get()), isEmpty);
      expect((await db.select(db.stickers).get()), isEmpty);
      expect((await db.select(db.moments).get()), isEmpty);
    });

    test('只删目标人格，不影响其他人格的数据', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final repo = DriftPersonaRepo(db, nowMs: () => _now);

      final a = await repo.create(name: 'A', personaJson: '{}');
      final b = await repo.create(name: 'B', personaJson: '{}');
      await db.into(db.messages).insert(MessagesCompanion.insert(
          personaId: b, sender: 'user', content: 'B的消息', createdAt: _now));

      await repo.delete(a);

      expect(await repo.getPersona(a), isNull);
      expect(await repo.getPersona(b), isNotNull);
      final msgs = await db.select(db.messages).get();
      expect(msgs.length, 1);
      expect(msgs.first.personaId, b);
    });
  },
      skip: hasSqlite
          ? false
          : '宿主缺少 native sqlite3 库（VM 测试环境），改在真机/集成测试运行');
}
