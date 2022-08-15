import 'package:astralnote_app/core/extensions/extensions.dart';
import 'package:astralnote_app/core/ui/custom_divider.dart';
import 'package:astralnote_app/core/ui/custom_layout.dart';
import 'package:astralnote_app/core/ui/hybrid_button.dart';
import 'package:astralnote_app/core/ui/hybrid_text_field.dart';
import 'package:astralnote_app/infrastructure/auth_repository.dart';
import 'package:astralnote_app/pages/login/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(authRepository: context.read<AuthRepository>()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: SafeArea(
          child: _Body(),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  _Body({Key? key}) : super(key: key);
  final emailController = TextEditingController(text: '');
  final passwordController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    final loginCubit = context.read<LoginCubit>();
    emailController.addListener(() => loginCubit.onUpdateEmailField(emailController.text));
    passwordController.addListener(() => loginCubit.onUpdatePasswordField(passwordController.text));

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        switch (state.status) {
          case LoginError.invalidCredentials:
            context.showSnackbarMessage('Wrong credentials');
            break;
          case LoginError.unexpected:
            context.showSnackbarMessage('Unexpected error');
            break;
          default:
        }
      },
      builder: (context, state) {
        return CustomLayout.scrollable(
          bottomWidgets: [
            const CustomDivider(showTopPadding: false),
            HybridButton(
              onPressed: emailController.text.isNotEmpty && passwordController.text.isNotEmpty
                  ? () => loginCubit.onLogin(email: emailController.value.text, password: passwordController.value.text)
                  : null,
              isLoading: state.inProgress,
              text: 'Login',
            ),
            HybridButton.secondary(
              onPressed: () async => loginCubit.onLogin(email: 'matvei.tikka@outlook.com', password: 'Test123!'),
              text: 'Quick login',
            ),
            CustomDivider.emptySmall(),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 10),
              HybridTextField(controller: emailController, placeholder: 'Email'),
              HybridTextField(controller: passwordController, placeholder: 'Password', isForPassword: true),
            ],
          ),
        );
      },
    );
  }
}
