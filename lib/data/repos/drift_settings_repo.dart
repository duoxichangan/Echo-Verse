import 'package:drift/drift.dart';

import '../../domain/contracts/settings_repo.dart';
import '../../domain/models/app_settings.dart';
import '../db/database.dart';

/// SettingsRepo 的 drift 实现（手册 INFRA-03）。
///
/// 单行配置表（id=1）。敏感的 api_key 不在此——走 SecretStore。
class DriftSettingsRepo implements SettingsRepo {
  final AppDatabase db;
  static const _rowId = 1;

  DriftSettingsRepo(this.db);

  @override
  Future<AppSettings> get() async {
    final row = await (db.select(db.settingsTable)
          ..where((t) => t.id.equals(_rowId)))
        .getSingleOrNull();
    if (row == null) return AppSettings.initial();
    return AppSettings(
      provider: _parseProvider(row.provider),
      baseUrl: row.baseUrl,
      model: row.model,
      activeHoursJson: row.activeHours,
      dailyProactiveQuota: row.dailyProactiveQuota,
      tokenBudget: row.tokenBudget,
    );
  }

  @override
  Future<void> update(AppSettings s) async {
    await db.into(db.settingsTable).insertOnConflictUpdate(
          SettingsTableCompanion.insert(
            id: const Value(_rowId),
            provider: s.provider.name,
            baseUrl: s.baseUrl,
            model: s.model,
            activeHours: Value(s.activeHoursJson),
            dailyProactiveQuota: Value(s.dailyProactiveQuota),
            tokenBudget: Value(s.tokenBudget),
          ),
        );
  }

  LlmProvider _parseProvider(String s) => LlmProvider.values.firstWhere(
        (p) => p.name == s,
        orElse: () => LlmProvider.deepseek,
      );
}
