import 'dart:async';

import 'package:astralnote_app/infrastructure/auth_repository.dart';
import 'package:astralnote_app/infrastructure/network_monitor_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'lifecycle_state.dart';
part 'lifecycle_cubit.freezed.dart';

class LifecycleCubit extends Cubit<LifecycleState> {
  LifecycleCubit({
    required NetworkMonitorRepository networkMonitorRepository,
    required AuthRepository authRepository,
  })  : _networkMonitorRepository = networkMonitorRepository,
        _authRepository = authRepository,
        super(LifecycleState.initial()) {
    _connectionStatusStream = _networkMonitorRepository.status.listen(_onNetworkStatusChanged);
    _isAuthenticatedSubscrption = _authRepository.isAuthenticatedObservable.listen(_onAuthStatusChanged);
  }

  final NetworkMonitorRepository _networkMonitorRepository;
  final AuthRepository _authRepository;

  StreamSubscription<NetworkStatus>? _connectionStatusStream;
  StreamSubscription<AuthStatus>? _isAuthenticatedSubscrption;

  void _onNetworkStatusChanged(NetworkStatus networkStatus) {
    if (networkStatus == NetworkStatus.online) {
      emit(state.copyWith(connectivity: NetworkStatus.online));
    } else {
      emit(state.copyWith(connectivity: NetworkStatus.offline));
    }
  }

  void onAppActivityStatusChanged(AppActivityStatus activityStatus) {
    if (activityStatus == AppActivityStatus.active) {
      emit(state.copyWith(activity: AppActivityStatus.active));
    } else {
      emit(state.copyWith(activity: AppActivityStatus.inactive));
    }
  }

  void _onAuthStatusChanged(AuthStatus authStatus) {
    emit(state.copyWith(authStatus: authStatus));
  }

  @override
  Future<void> close() async {
    await _connectionStatusStream?.cancel();
    await _isAuthenticatedSubscrption?.cancel();
    return super.close();
  }
}
