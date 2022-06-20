// ignore_for_file: deprecated_member_use

import 'package:astralnote_app/global/blocks/auth/auth_cubit.dart';
import 'package:astralnote_app/infrastructure/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController(text: '');
    final passwordController = TextEditingController(text: '');
    final authCubit = BlocProvider.of<AuthCubit>(context);

    return PlatformScaffold(
      appBar: PlatformAppBar(title: const Text('Login')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PlatformText('Email'),
              PlatformTextField(controller: emailController),
              const SizedBox(height: 10),
              PlatformText('Password'),
              PlatformTextField(controller: passwordController),
              const SizedBox(height: 10),
              PlatformButton(
                onPressed: () => authCubit.login(emailController.value.text, passwordController.value.text),
                color: Colors.green,
                child: const Text('Login'),
              ),
              const SizedBox(height: 10),
              PlatformButton(
                onPressed: () async => authCubit.login('matvei.tikka@outlook.com', 'Test123!'),
                color: Colors.red,
                child: const Text('Quick'),
              ),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    uninitialized: (inProgress, error) {
                      if (inProgress) return PlatformCircularProgressIndicator();
                      if (error == AuthError.userNotExist) return const Text('Wrong email');
                      if (error == AuthError.invalidCredentials) return const Text('Wrong password');
                      if (error != null) return const Text('Something went wrong. Try again later.');
                      return const Text('Please sign in :)');
                    },
                    orElse: () => const SizedBox(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
