import 'package:astralnote_app/global/blocks/auth/auth_cubit.dart';
import 'package:astralnote_app/infrastructure/auth_repository.dart';
import 'package:astralnote_app/router_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthGuard extends StatelessWidget {
  const AuthGuard({
    required this.child,
    required this.navigator,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final GlobalKey<NavigatorState> navigator;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        switch (state.status) {
          case AuthStatus.authenticated:
            navigator.currentState?.pushNamedAndRemoveUntil(Routes.main.name, (route) => false);
            break;
          case AuthStatus.unauthenticated:
            navigator.currentState?.pushNamedAndRemoveUntil(Routes.start.name, (route) => false);
            break;
          default:
        }
      },
      child: child,
    );
  }
}
