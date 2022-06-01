import 'package:astralnote_app/modules/secure_storage_module.dart';

enum StorageKeys { refreshToken, accessToken }

class SecureStorageRepository {
  static SecureStorageRepository? _instance;

  factory SecureStorageRepository() => _instance ??= SecureStorageRepository._();

  SecureStorageRepository._();

  Future<String?> getWithKey(StorageKeys key) async {
    final storage = SecureStorageModule().instance;
    final value = await storage.read(key: key.name);
    return value;
  }

  Future<void> setWithKey(StorageKeys key, String value) async {
    final storage = SecureStorageModule().instance;
    await storage.write(key: key.name, value: value);
  }

  Future<void> removeWithKey({required StorageKeys key}) async {
    final storage = SecureStorageModule().instance;
    await storage.delete(key: key.name);
  }
}
