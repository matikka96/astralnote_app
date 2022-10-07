//TODO: Perform actual network ping test before emitting online

import 'dart:async';

import 'package:astralnote_app/modules/connectivity_module.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rxdart/subjects.dart';

enum NetworkStatus { online, offline }

class NetworkMonitorRepository {
  NetworkMonitorRepository({
    required ConnectivityModule connectivityModule,
  }) : _connectivity = connectivityModule.instance {
    _connectivity.onConnectivityChanged.listen(
      (status) => _controller.add(status != ConnectivityResult.none ? NetworkStatus.online : NetworkStatus.offline),
    );
  }

  final Connectivity _connectivity;

  final _controller = BehaviorSubject<NetworkStatus>();

  Stream<NetworkStatus> get status => _controller.stream;
}
