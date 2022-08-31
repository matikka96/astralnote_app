part of 'lifecycle_cubit.dart';

enum ConnectivityStatus { online, offline }

enum AppActivityStatus { active, inactive }

@freezed
class LifecycleState with _$LifecycleState {
  const factory LifecycleState({
    required ConnectivityStatus connectivity,
    required AppActivityStatus activity,
    required AuthStatus authStatus,
  }) = _LifecycleState;

  const LifecycleState._();

  factory LifecycleState.initial() {
    return const LifecycleState(
      connectivity: ConnectivityStatus.offline,
      activity: AppActivityStatus.active,
      authStatus: AuthStatus.uninitialized,
    );
  }

  bool get _appIsOnline => connectivity == ConnectivityStatus.online ? true : false;

  bool get _appIsActive => activity == AppActivityStatus.active ? true : false;

  bool get _userIsAuthenticated => authStatus == AuthStatus.authenticated ? true : false;

  bool get repeatedSyncIsOn => _appIsOnline && _appIsActive && _userIsAuthenticated;
}
