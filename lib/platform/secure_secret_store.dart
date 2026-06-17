import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../domain/contracts/secret_store.dart';

/// SecretStore 的 flutter_secure_storage 实现（手册 INFRA-02）。
///
/// **API key 只存这里**：底层走 Android Keystore 加密，绝不入 SQLite、绝不写日志。
class SecureSecretStore implements SecretStore {
  final FlutterSecureStorage _storage;

  SecureSecretStore([FlutterSecureStorage? storage])
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}
