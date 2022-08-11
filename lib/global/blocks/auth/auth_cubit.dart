import 'package:astralnote_app/infrastructure/auth_repository.dart';
import 'package:astralnote_app/infrastructure/secure_storage_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.dart';
part 'auth_cubit.freezed.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final SecureStorageRepository _secureStorageRepository;

  AuthCubit({
    required AuthRepository authRepository,
    required SecureStorageRepository secureStorageRepository,
  })  : _authRepository = authRepository,
        _secureStorageRepository = secureStorageRepository,
        super(AuthState.initial()) {
    _init();
  }

  _init() async {
    final refreshToken = await _secureStorageRepository.getWithKey(StorageKeys.refreshToken);
    if (refreshToken != null) {
      emit(AuthState.authenticated());
    } else {
      emit(AuthState.unauthenticated());
    }
  }

  login(String email, String password) async {
    emit(AuthState.uninitialized(inProgress: true));
    final failureOrAuth = await _authRepository.login(email: email, password: password);
    failureOrAuth.fold(
      (error) => emit(AuthState.uninitialized(inProgress: false, authError: error)),
      (auth) async {
        await _secureStorageRepository.setWithKey(StorageKeys.refreshToken, auth.refreshToken);
        await _secureStorageRepository.setWithKey(StorageKeys.accessToken, auth.accessToken);
        emit(AuthState.authenticated());
      },
    );
  }

  logout() async {
    await _secureStorageRepository.removeWithKey(key: StorageKeys.refreshToken);
    emit(AuthState.unauthenticated());
  }

  printTokens() async {
    final refresh = await _secureStorageRepository.getWithKey(StorageKeys.refreshToken);
    final access = await _secureStorageRepository.getWithKey(StorageKeys.accessToken);
    print('Access: $access');
    print('Refresh: $refresh');
  }

  deleteAccessToken() async => _secureStorageRepository.removeWithKey(key: StorageKeys.accessToken);
  deleteRefreshToken() async => _secureStorageRepository.removeWithKey(key: StorageKeys.refreshToken);

  updateState(AuthState newState) async => emit(newState);
}
