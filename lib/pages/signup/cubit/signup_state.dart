part of 'signup_cubit.dart';

@freezed
class SignupState with _$SignupState {
  const factory SignupState.idle() = _Idle;
  const factory SignupState.userAlreadyExist() = _UserAlreadyExist;
  const factory SignupState.success() = _Success;
  const factory SignupState.failure() = _Failure;
}
