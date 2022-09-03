import 'package:astralnote_app/domain/user/user.dart';
import 'package:astralnote_app/infrastructure/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_state.dart';
part 'user_cubit.freezed.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(UserState.initial());

  final UserRepository _userRepository;

  onLoadCurrentUser() async {
    if (state.user == null) {
      final failureOrCurrentUser = await _userRepository.getCurrentUser();
      failureOrCurrentUser.fold(
        (error) => emit(state.copyWith(status: UserStatus.loadingFailed)),
        (user) => emit(state.copyWith(user: user, status: UserStatus.loaded)),
      );
    }
  }

  onDelete() async {
    if (state.user == null) {
      final failreOrUserDeleted = await _userRepository.deleteCurrentUser(userId: state.user!.id);
      failreOrUserDeleted.fold(
        (error) => emit(state.copyWith(status: UserStatus.userDeletionFailed)),
        (_) => emit(state.copyWith(status: UserStatus.userDeleted)),
      );
    }
  }

  void onDispose() {
    emit(UserState.initial());
  }
}
