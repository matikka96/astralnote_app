import 'package:astralnote_app/infrastructure/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.dart';
part 'login_cubit.freezed.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(LoginState.initial());

  final AuthRepository _authRepository;

  void onUpdateEmailField(String email) {
    emit(state.copyWith(email: email));
  }

  void onUpdatePasswordField(String password) {
    emit(state.copyWith(password: password));
  }

  Future<void> onLogin({required String email, required String password}) async {
    emit(state.copyWith(inProgress: true));
    final failureOrAuth = await _authRepository.login(email: email, password: password);
    failureOrAuth.fold(
      (error) {
        // TODO: Error is not parsed properly at the moment
        switch (error) {
          case AuthError.invalidCredentials:
            emit(state.copyWith(status: LoginError.invalidCredentials));
            break;
          default:
            emit(state.copyWith(status: LoginError.unexpected));
        }
      },
      (auth) => emit(state.copyWith(status: LoginError.none)),
    );
    emit(state.copyWith(inProgress: false, status: LoginError.none));
  }
}
