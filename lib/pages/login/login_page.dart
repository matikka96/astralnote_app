import 'package:astralnote_app/global/blocks/auth/auth_cubit.dart';
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(controller: emailController),
              TextField(controller: passwordController),
              const Divider(),
              MaterialButton(
                onPressed: () => authCubit.login(emailController.value.text, passwordController.value.text),
                color: Colors.yellow,
                child: const Text('Login'),
              ),
              const Divider(),
              MaterialButton(
                onPressed: () async => authCubit.login('matvei.tikka@outlook.com', 'Test123!'),
                color: Colors.red,
                child: const Text('Quick'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
