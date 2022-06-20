part of 'auth_cubit.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.uninitialized({
    required bool inProgress,
    AuthError? authError,
  }) = _Uninitialized;

  const factory AuthState.authenticated({
    bool? online,
  }) = _Authenticated;

  const factory AuthState.unauthenticated() = _Unauthenticated;
}
