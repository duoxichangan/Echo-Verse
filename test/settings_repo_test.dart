import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:virtual/data/db/database.dart';
import 'package:virtual/data/repos/drift_settings_repo.dart';
import 'package:virtual/domain/models/app_settings.dart';

/// 注意：drift 需要 native sqlite3 库。`flutter test` 跑在 Dart VM 上，
/// sqlite3_flutter_libs 只为真机/桌面 app 提供原生库，VM 下可能缺失。
/// 直接用 sqlite3 包探测（缺库时同步抛出）：缺则整组跳过。
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

  group('DriftSettingsRepo', () {
    late AppDatabase db;
    late DriftSettingsRepo repo;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      repo = DriftSettingsRepo(db);
    });

    tearDown(() async => db.close());

    test('未写入时返回初始配置', () async {
      final s = await repo.get();
      expect(s.provider, LlmProvider.deepseek);
      expect(s.baseUrl, 'https://api.deepseek.com');
    });

    test('保存后能读回相同配置（单行覆盖）', () async {
      await repo.update(const AppSettings(
        provider: LlmProvider.openai,
        baseUrl: 'https://api.openai.com/v1',
        model: 'gpt-4o',
        dailyProactiveQuota: 9,
        tokenBudget: 8000,
        userName: '阿强',
        userAvatarPath: '/avatars/me.png',
        momentFrequency: 70,
      ));
      final s = await repo.get();
      expect(s.provider, LlmProvider.openai);
      expect(s.model, 'gpt-4o');
      expect(s.dailyProactiveQuota, 9);
      expect(s.tokenBudget, 8000);
      // v2 新增字段往返
      expect(s.userName, '阿强');
      expect(s.userAvatarPath, '/avatars/me.png');
      expect(s.momentFrequency, 70);

      // 再次更新应覆盖而非新增行
      await repo.update(s.copyWith(model: 'gpt-4o-mini'));
      final again = await repo.get();
      expect(again.model, 'gpt-4o-mini');
      expect(again.userName, '阿强'); // 其它字段保留
    });

    test('默认配置含 v2 字段默认值', () async {
      final s = await repo.get(); // 未写入 → initial
      expect(s.userName, '我');
      expect(s.momentFrequency, 30);
    });
  },
      skip: hasSqlite
          ? false
          : '宿主缺少 native sqlite3 库（VM 测试环境），改在真机/集成测试运行');
}

