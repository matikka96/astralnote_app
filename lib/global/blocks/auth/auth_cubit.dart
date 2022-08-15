import 'dart:async';

import 'package:astralnote_app/infrastructure/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.dart';
part 'auth_cubit.freezed.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(AuthState.initial()) {
    _isAuthenticatedSubscrption = _authRepository.isAuthenticatedObservable.listen(_setAuthStatus);
  }

  final AuthRepository _authRepository;

  StreamSubscription<AuthStatus>? _isAuthenticatedSubscrption;

  onLogout() async => _authRepository.logout();

  _setAuthStatus(AuthStatus authStatus) async {
    emit(state.copyWith(status: authStatus));
    if (authStatus == AuthStatus.unauthenticated) emit(state.copyWith(status: AuthStatus.uninitialized));
  }

  onPrintTokens() async => _authRepository.printTokens();

  onBreakAccess() async => _authRepository.breakAccess();

  @override
  Future<void> close() async {
    await _isAuthenticatedSubscrption?.cancel();
    return super.close();
  }
}
