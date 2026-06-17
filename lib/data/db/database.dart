import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Personas,
    Messages,
    SessionSummaries,
    Facts,
    RelationshipStates,
    OpenLoops,
    Stickers,
    Moments,
    SettingsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  /// 内存库，供测试使用。
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          // 检索 / 衰减性能索引（DATA-01）
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_facts_importance_ref '
            'ON facts (importance, last_referenced_at)',
          );
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_messages_persona_created '
            'ON messages (persona_id, created_at)',
          );
        },
        onUpgrade: (m, from, to) async {
          // v1→v2：settings 加 用户昵称/头像 + 朋友圈活跃度。
          if (from < 2) {
            await m.addColumn(settingsTable, settingsTable.userName);
            await m.addColumn(settingsTable, settingsTable.userAvatarPath);
            await m.addColumn(settingsTable, settingsTable.momentFrequency);
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'virtual.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
