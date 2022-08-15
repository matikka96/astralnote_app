part of 'login_cubit.dart';

enum LoginError { none, invalidCredentials, unexpected }

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    required String email,
    required String password,
    required bool inProgress,
    required LoginError status,
  }) = _LoginState;

  factory LoginState.initial() {
    return const LoginState(
      email: '',
      password: '',
      inProgress: false,
      status: LoginError.none,
    );
  }
}
