part of 'auth_cubit.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.uninitialized() = _Uninitialized;

  const factory AuthState.authenticated() = _Authenticated;

  const factory AuthState.unauthenticated({AuthError? authError}) = _Unauthenticated;
}
