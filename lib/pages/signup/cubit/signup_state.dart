part of 'signup_cubit.dart';

enum SingupStatus { idle, userAlreadyExist, success, failure }

@freezed
class SignupState with _$SignupState {
  const factory SignupState({
    required String email,
    required String password,
    required String passwordRepeated,
    required SingupStatus status,
  }) = _SignupState;

  const SignupState._();

  factory SignupState.initial() {
    return const SignupState(
      email: '',
      password: '',
      passwordRepeated: '',
      status: SingupStatus.idle,
    );
  }

  bool? get emailIsOK {
    if (email.isEmpty) return null;
    return email.isValidEmail;
  }

  bool? get passwordIsOk {
    if (password.isEmpty) return null;
    return password.length > 5;
  }

  bool? get passwordsAreMatching {
    if (passwordIsOk != null && passwordIsOk!) return password == passwordRepeated;
    return null;
  }

  bool get allFieldsAreValid {
    if (emailIsOK != null && passwordIsOk != null && passwordsAreMatching != null) {
      return emailIsOK! && passwordIsOk! && passwordsAreMatching!;
    } else {
      return false;
    }
  }
}
