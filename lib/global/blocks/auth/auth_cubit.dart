import 'package:astralnote_app/infrastructure/auth_repository.dart';
import 'package:astralnote_app/infrastructure/secure_storage_repository.dart';
import 'package:astralnote_app/models/auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.dart';
part 'auth_cubit.freezed.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState.authenticated());

  init() async {
    final refreshToken = await SecureStorageRepository().getWithKey(StorageKeys.refreshToken);
    if (refreshToken != null) {
      emit(const AuthState.authenticated());
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  login(String email, String password) async {
    final failureOrAuth = await AuthRepository().login(email: email, password: password);
    failureOrAuth.fold(
      (error) => emit(AuthState.unauthenticated(authError: error)),
      (auth) async {
        await SecureStorageRepository().setWithKey(StorageKeys.refreshToken, auth.refreshToken);
        await SecureStorageRepository().setWithKey(StorageKeys.accessToken, auth.accessToken);
        emit(const AuthState.authenticated());
      },
    );
  }

  logout() async {
    await SecureStorageRepository().removeWithKey(key: StorageKeys.refreshToken);
    emit(const AuthState.unauthenticated());
  }

  printTokens() async {
    final refresh = await SecureStorageRepository().getWithKey(StorageKeys.refreshToken);
    final access = await SecureStorageRepository().getWithKey(StorageKeys.accessToken);
    print('Access: $access');
    print('Refresh: $refresh');
  }

  deleteAccessToken() async => SecureStorageRepository().removeWithKey(key: StorageKeys.accessToken);
  deleteRefreshToken() async => SecureStorageRepository().removeWithKey(key: StorageKeys.refreshToken);
}
