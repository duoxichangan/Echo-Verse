/// 模型服务商。
enum LlmProvider { deepseek, openai, claude }

/// 应用配置（说明书 §6.9）。
///
/// 注意：[apiKey] **绝不**包含在此模型里，也绝不入 SQLite——它只存
/// flutter_secure_storage（见 SecretStore 契约）。这里只放可落库的项。
class AppSettings {
  final LlmProvider provider;
  final String baseUrl;
  final String model;

  /// 作息表 JSON（活跃/安静时段），活动调度中枢使用。
  final String activeHoursJson;

  /// 每日主动配额。
  final int dailyProactiveQuota;

  /// 单次上下文 token 预算。
  final int tokenBudget;

  /// 全局“我”——用户昵称与头像路径（所有数字人共用）。
  final String userName;
  final String? userAvatarPath;

  /// 朋友圈自发活跃度 0–100（0=从不自发）。
  final int momentFrequency;

  const AppSettings({
    required this.provider,
    required this.baseUrl,
    required this.model,
    this.activeHoursJson = '{}',
    this.dailyProactiveQuota = 12,
    this.tokenBudget = 4000,
    this.userName = '我',
    this.userAvatarPath,
    this.momentFrequency = 30,
  });

  /// 合理的默认配置（DeepSeek）。
  factory AppSettings.initial() => const AppSettings(
        provider: LlmProvider.deepseek,
        baseUrl: 'https://api.deepseek.com',
        model: 'deepseek-chat',
      );

  AppSettings copyWith({
    LlmProvider? provider,
    String? baseUrl,
    String? model,
    String? activeHoursJson,
    int? dailyProactiveQuota,
    int? tokenBudget,
    String? userName,
    String? userAvatarPath,
    int? momentFrequency,
  }) {
    return AppSettings(
      provider: provider ?? this.provider,
      baseUrl: baseUrl ?? this.baseUrl,
      model: model ?? this.model,
      activeHoursJson: activeHoursJson ?? this.activeHoursJson,
      dailyProactiveQuota: dailyProactiveQuota ?? this.dailyProactiveQuota,
      tokenBudget: tokenBudget ?? this.tokenBudget,
      userName: userName ?? this.userName,
      userAvatarPath: userAvatarPath ?? this.userAvatarPath,
      momentFrequency: momentFrequency ?? this.momentFrequency,
    );
  }
}
