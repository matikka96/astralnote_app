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
    final authCubit = BlocProvider.of<AuthCubit>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Email'),
              TextField(controller: emailController, ),
              const SizedBox(height: 10),
              const Text('Password'),
              TextField(controller: passwordController),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () async => authCubit.login('matvei.tikka@outlook.com', 'Test123!'),
                    child: const Text('Quick'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => authCubit.login(emailController.value.text, passwordController.value.text),
                    child: const Text('Login'),
                  ),
                ],
              ),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    uninitialized: (inProgress, error) {
                      if (inProgress) return const CircularProgressIndicator();
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
