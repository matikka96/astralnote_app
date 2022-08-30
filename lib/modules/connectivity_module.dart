import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityModule {
  ConnectivityModule._internal();
  static final _singleton = ConnectivityModule._internal();
  factory ConnectivityModule() => _singleton;

  final instance = Connectivity();
}
