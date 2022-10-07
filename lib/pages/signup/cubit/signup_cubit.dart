import 'package:astralnote_app/core/extensions/extensions.dart';
import 'package:astralnote_app/infrastructure/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_state.dart';
part 'signup_cubit.freezed.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit({
    required this.authRepository,
  }) : super(SignupState.initial());

  final AuthRepository authRepository;

  void onUpdateEmailField(String newValue) => emit(state.copyWith(email: newValue));

  void onUpdatePasswordField(String newValue) => emit(state.copyWith(password: newValue));

  void onUpdatePasswordRepeatedField(String newValue) => emit(state.copyWith(passwordRepeated: newValue));

  void test() => emit(state.copyWith(status: SingupStatus.success));

  Future<void> onSignup({required String email, required String password}) async {
    final failureOrRoleId = await authRepository.getUserRoleId();
    await failureOrRoleId.fold(
      (l) {},
      (roleId) async {
        final failureOrSignup = await authRepository.signup(email: email, password: password, roleId: roleId);
        failureOrSignup.fold(
          (authError) {
            switch (authError) {
              case AuthError.userAlreadyExist:
                emit(state.copyWith(status: SingupStatus.userAlreadyExist));
                break;
              default:
                emit(state.copyWith(status: SingupStatus.failure));
            }
          },
          (_) => emit(state.copyWith(status: SingupStatus.success)),
        );
      },
    );
  }
}
