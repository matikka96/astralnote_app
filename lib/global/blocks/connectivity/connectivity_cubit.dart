import 'dart:async';

import 'package:astralnote_app/infrastructure/network_monitor_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'connectivity_state.dart';
part 'connectivity_cubit.freezed.dart';

class ConnectivityCubit extends Cubit<ConnectivityState> {
  ConnectivityCubit({
    required NetworkMonitorRepository networkMonitorRepository,
  })  : _networkMonitorRepository = networkMonitorRepository,
        super(const ConnectivityState.offline()) {
    _connectionStatusStream = _networkMonitorRepository.status.listen(_onConnectionStatusChanged);
  }

  final NetworkMonitorRepository _networkMonitorRepository;

  StreamSubscription<NetworkStatus>? _connectionStatusStream;

  void _onConnectionStatusChanged(NetworkStatus status) {
    print(status);
    if (status == NetworkStatus.online) {
      emit(const ConnectivityState.online());
    } else {
      emit(const ConnectivityState.offline());
    }
  }

  @override
  Future<void> close() async {
    await _connectionStatusStream?.cancel();
    return super.close();
  }
}
