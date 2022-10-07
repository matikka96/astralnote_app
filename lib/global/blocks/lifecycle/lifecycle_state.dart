part of 'lifecycle_cubit.dart';

enum AppActivityStatus { active, inactive }

@freezed
class LifecycleState with _$LifecycleState {
  const factory LifecycleState({
    required NetworkStatus connectivity,
    required AppActivityStatus activity,
    required AuthStatus authStatus,
  }) = _LifecycleState;

  const LifecycleState._();

  factory LifecycleState.initial() {
    return const LifecycleState(
      connectivity: NetworkStatus.offline,
      activity: AppActivityStatus.active,
      authStatus: AuthStatus.unauthenticated,
    );
  }

  bool get appIsOnline => connectivity == NetworkStatus.online ? true : false;

  bool get appIsActive => activity == AppActivityStatus.active ? true : false;

  bool get userIsAuthenticated => authStatus == AuthStatus.authenticated ? true : false;

  bool get isOnlineAndActiveAndAuthenticated => appIsOnline && appIsActive && userIsAuthenticated;
}
