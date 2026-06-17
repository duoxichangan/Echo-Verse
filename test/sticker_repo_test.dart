import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:virtual/data/db/database.dart';
import 'package:virtual/data/repos/drift_sticker_repo.dart';

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

  group('DriftStickerRepo.pathByLabel 容错匹配', () {
    late AppDatabase db;
    late DriftStickerRepo repo;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      repo = DriftStickerRepo(db);
      await db.into(db.personas).insert(PersonasCompanion.insert(
            name: 'p', personaJson: '{}', personaJsonInitial: '{}',
            createdAt: 0, updatedAt: 0,
          ));
      await repo.addSticker(personaId: 1, filePath: '/s/happy.png', label: '开心');
      await repo.addSticker(filePath: '/s/global.png', label: 'OK'); // 全局
    });
    tearDown(() async => db.close());

    test('精确匹配', () async {
      expect(await repo.pathByLabel(1, '开心'), '/s/happy.png');
    });

    test('大小写/空白容错', () async {
      expect(await repo.pathByLabel(1, ' ok '), '/s/global.png');
    });

    test('互相包含容错（“开心笑”命中“开心”）', () async {
      expect(await repo.pathByLabel(1, '开心笑'), '/s/happy.png');
    });

    test('完全不沾边返回 null', () async {
      expect(await repo.pathByLabel(1, '愤怒'), isNull);
    });

    test('全局表情对任意 persona 可见', () async {
      expect(await repo.pathByLabel(1, 'OK'), '/s/global.png');
    });
  },
      skip: hasSqlite
          ? false
          : '宿主缺少 native sqlite3 库（VM 测试环境），改在真机/集成测试运行');
}
