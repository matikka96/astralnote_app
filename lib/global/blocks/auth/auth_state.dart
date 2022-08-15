part of 'auth_cubit.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    required AuthStatus status,
    required bool inProgress,
    AuthError? authError,
  }) = _AuthState;

  factory AuthState.initial() {
    return const AuthState(status: AuthStatus.uninitialized, inProgress: false);
  }

  factory AuthState.authenticated() {
    return const AuthState(status: AuthStatus.authenticated, inProgress: false);
  }

  factory AuthState.unauthenticated() {
    return const AuthState(status: AuthStatus.unauthenticated, inProgress: false);
  }

  factory AuthState.uninitialized({bool? inProgress, AuthError? authError}) {
    return AuthState(status: AuthStatus.uninitialized, inProgress: inProgress ?? false, authError: authError);
  }
}
