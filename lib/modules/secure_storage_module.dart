import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageModule {
  final instance = const FlutterSecureStorage();

  SecureStorageModule._internal();

  static final _singleton = SecureStorageModule._internal();

  factory SecureStorageModule() => _singleton;
}
