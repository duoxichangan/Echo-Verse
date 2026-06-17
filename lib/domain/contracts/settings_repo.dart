import '../models/app_settings.dart';

/// 配置读写契约（手册 INFRA-03）。
///
/// 可落库项走 SQLite；敏感的 api_key 走 SecretStore，不在此接口出现。
abstract class SettingsRepo {
  /// 读取当前配置；首次启动时返回 AppSettings.initial()。
  Future<AppSettings> get();

  /// 保存配置。
  Future<void> update(AppSettings settings);
}
