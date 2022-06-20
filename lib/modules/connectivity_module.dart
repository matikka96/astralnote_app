import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityModule {
  // static get instance => Connectivity();
  final instance = Connectivity();

  ConnectivityModule._internal();

  static final _singleton = ConnectivityModule._internal();

  factory ConnectivityModule() => _singleton;
}

// class ConnectivityModule {
//   static final ConnectivityModule _singleton = ConnectivityModule._internal();

//   static final Connectivity _connectivity = Connectivity();

//   factory ConnectivityModule() => _singleton;

//   static Connectivity get instance => _connectivity;

//   ConnectivityModule._internal();
// }
