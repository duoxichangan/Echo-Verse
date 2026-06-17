import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:virtual/app/ops/backup_service.dart';
import 'package:virtual/data/db/database.dart';

bool _sqliteAvailable() {
  try {
    sqlite3.openInMemory().dispose();
    return true;
  } catch (_) {
    return false;
  }
}

void main() {
  final hasSqlite = _sqliteAvailable();

  group('BackupService 导出/导入往返', () {
    test('导出后导入能完整还原', () async {
      final db1 = AppDatabase(NativeDatabase.memory());
      // 造数据。
      final pid = await db1.into(db1.personas).insert(PersonasCompanion.insert(
            name: '小桃',
            personaJson: '{"L0_core_rules":["绝不承认是AI"]}',
            personaJsonInitial: '{}',
            userAlias: const Value('笨蛋'),
            createdAt: 100,
            updatedAt: 100,
          ));
      await db1.into(db1.messages).insert(MessagesCompanion.insert(
            personaId: pid,
            sender: 'user',
            content: '在吗',
            createdAt: 101,
          ));
      await db1.into(db1.facts).insert(FactsCompanion.insert(
            personaId: pid,
            content: '用户养了猫',
            lastReferencedAt: 102,
            createdAt: 102,
            importance: const Value(0.8),
          ));

      final json = await BackupService(db1).exportToJson();
      await db1.close();

      // 导入到全新空库。
      final db2 = AppDatabase(NativeDatabase.memory());
      await BackupService(db2).importFromJson(json);

      final personas = await db2.select(db2.personas).get();
      final messages = await db2.select(db2.messages).get();
      final facts = await db2.select(db2.facts).get();

      expect(personas.length, 1);
      expect(personas.first.name, '小桃');
      expect(personas.first.userAlias, '笨蛋');
      expect(messages.length, 1);
      expect(messages.first.content, '在吗');
      expect(facts.length, 1);
      expect(facts.first.content, '用户养了猫');
      expect(facts.first.importance, 0.8);

      await db2.close();
    });

    test('导入覆盖旧数据（不堆叠）', () async {
      final db = AppDatabase(NativeDatabase.memory());
      // 旧数据。
      await db.into(db.personas).insert(PersonasCompanion.insert(
            name: '旧人',
            personaJson: '{}',
            personaJsonInitial: '{}',
            createdAt: 1,
            updatedAt: 1,
          ));
      // 备份只含一个新人。
      final db0 = AppDatabase(NativeDatabase.memory());
      await db0.into(db0.personas).insert(PersonasCompanion.insert(
            name: '新人',
            personaJson: '{}',
            personaJsonInitial: '{}',
            createdAt: 2,
            updatedAt: 2,
          ));
      final json = await BackupService(db0).exportToJson();
      await db0.close();

      await BackupService(db).importFromJson(json);
      final personas = await db.select(db.personas).get();
      expect(personas.length, 1); // 旧人被清掉
      expect(personas.first.name, '新人');
      await db.close();
    });
  },
      skip: hasSqlite
          ? false
          : '宿主缺少 native sqlite3 库（VM 测试环境），改在真机/集成测试运行');
}
