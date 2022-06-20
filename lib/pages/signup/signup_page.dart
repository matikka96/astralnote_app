// ignore_for_file: deprecated_member_use

import 'package:astralnote_app/infrastructure/auth_repository.dart';
import 'package:astralnote_app/modules/dio_module.dart';
import 'package:astralnote_app/pages/signup/cubit/signup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(authRepository: AuthRepository(dioModule: DioModule())),
      child: BlocListener<SignupCubit, SignupState>(
        listener: (context, state) {
          print(state);
        },
        child: const _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final signupCubit = BlocProvider.of<SignupCubit>(context);

    final emailController = TextEditingController(text: '');
    final passwordController = TextEditingController(text: '');

    return PlatformScaffold(
      appBar: PlatformAppBar(title: const Text('Sign up')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              PlatformTextField(controller: emailController),
              const Divider(),
              PlatformTextField(controller: passwordController),
              const Divider(),
              PlatformButton(
                onPressed: () => signupCubit.signup(email: emailController.text, password: passwordController.text),
                color: Colors.amber,
                child: const Text('Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
