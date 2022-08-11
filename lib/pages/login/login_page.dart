import 'package:astralnote_app/core/extensions/extensions.dart';
import 'package:astralnote_app/core/ui/hybrid_button.dart';
import 'package:astralnote_app/core/ui/hybrid_text_field.dart';
import 'package:astralnote_app/global/blocks/auth/auth_cubit.dart';
import 'package:astralnote_app/infrastructure/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController(text: '');
    final passwordController = TextEditingController(text: '');
    final authCubit = context.read<AuthCubit>();

    switch (authCubit.state.authError) {
      case AuthError.invalidCredentials:
        context.showSnackbarMessage('Wrong credentials');
        break;
      default:
    }

    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) => previous.authError != current.authError,
      listener: (context, state) {
        if (state.authError != null) context.showSnackbarMessage('Wrong credentials');
      },
      buildWhen: (previous, current) => previous.inProgress != current.inProgress,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Login')),
          body: SafeArea(
            child: GestureDetector(
              onTap: () => context.hideKeyboard,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 10),
                  ListTile(
                    title: HybridTextField(controller: emailController, placeholder: 'Email'),
                  ),
                  ListTile(
                    title: HybridTextField(controller: passwordController, placeholder: 'Password'),
                  ),
                  const Divider(),
                  ListTile(
                    title: HybridButton(
                      onPressed: () => authCubit.login(emailController.value.text, passwordController.value.text),
                      isLoading: state.inProgress,
                      text: 'Login',
                    ),
                  ),
                  ListTile(
                    title: HybridButton.secondary(
                      onPressed: () async => authCubit.login('matvei.tikka@outlook.com', 'Test123!'),
                      text: 'Quick',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
