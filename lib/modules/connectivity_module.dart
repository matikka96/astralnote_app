import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityModule {
  final instance = Connectivity();

  ConnectivityModule._internal();

  static final _singleton = ConnectivityModule._internal();

  factory ConnectivityModule() => _singleton;
}
