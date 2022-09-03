part of 'user_cubit.dart';

enum UserStatus { idle, loaded, loadingFailed, userDeleted, userDeletionFailed }

@freezed
class UserState with _$UserState {
  const factory UserState({
    required User? user,
    required UserStatus status,
  }) = _UserState;

  factory UserState.initial() {
    return const UserState(
      user: null,
      status: UserStatus.idle,
    );
  }
}
