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
    _isAuthenticatedSubscrption = _authRepository.isAuthenticatedObservable.listen(_onSetAuthStatus);
  }

  final AuthRepository _authRepository;

  StreamSubscription<AuthStatus>? _isAuthenticatedSubscrption;

  Future<void> onLogout() => _authRepository.logout();

  void _onSetAuthStatus(AuthStatus authStatus) {
    emit(state.copyWith(status: authStatus));
  }

  Future<void> onPrintTokens() => _authRepository.printTokens();

  Future<void> onBreakAccess() => _authRepository.breakAccess();

  @override
  Future<void> close() async {
    await _isAuthenticatedSubscrption?.cancel();
    return super.close();
  }
}
