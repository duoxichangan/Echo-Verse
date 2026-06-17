/// 密钥安全存储契约（手册 INFRA-02）。
///
/// **API key 只存这里，绝不入 SQLite、绝不写日志。**
/// 实现封装 flutter_secure_storage。
abstract class SecretStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

/// 约定的 key 名常量，避免散落字符串。
class SecretKeys {
  static const apiKey = 'llm_api_key';
}
