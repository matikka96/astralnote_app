import 'package:astralnote_app/modules/secure_storage_module.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum StorageKeys { refreshToken, accessToken, notesSortOrder, appTheme }

class SecureStorageRepository {
  SecureStorageRepository({
    required SecureStorageModule secureStorageModule,
  }) : _secureStorage = secureStorageModule.instance;

  final FlutterSecureStorage _secureStorage;

  Future<String?> getWithKey(StorageKeys key) async {
    final value = await _secureStorage.read(key: key.name);
    return value;
  }

  Future<void> setWithKey(StorageKeys key, String value) async {
    await _secureStorage.write(key: key.name, value: value);
  }

  Future<void> removeWithKey({required StorageKeys key}) async {
    await _secureStorage.delete(key: key.name);
  }
}
