import 'package:astralnote_app/infrastructure/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_state.dart';
part 'signup_cubit.freezed.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit({
    required this.authRepository,
  }) : super(const SignupState.idle());

  final AuthRepository authRepository;

  signup({required String email, required String password}) async {
    final failureOrRoleId = await authRepository.getUserRoleId();
    await failureOrRoleId.fold(
      (l) => null,
      (roleId) async {
        final failureOrSignup = await authRepository.signup(email: email, password: password, roleId: roleId);
        failureOrSignup.fold(
          (error) => error == AuthError.userAlreadyExist
              ? emit(const SignupState.userAlreadyExist())
              : emit(const SignupState.failure()),
          (_) => emit(const SignupState.success()),
        );
      },
    );
  }
}
