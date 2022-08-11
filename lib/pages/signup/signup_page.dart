import 'package:astralnote_app/core/extensions/extensions.dart';
import 'package:astralnote_app/core/ui/hybrid_button.dart';
import 'package:astralnote_app/core/ui/hybrid_text_field.dart';
import 'package:astralnote_app/infrastructure/auth_repository.dart';
import 'package:astralnote_app/pages/signup/cubit/signup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(authRepository: context.read<AuthRepository>()),
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

    return Scaffold(
      appBar: AppBar(title: const Text('Sign up')),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => context.hideKeyboard,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 10),
              ListTile(
                title: HybridTextField(controller: emailController, placeholder: 'Email'),
              ),
              ListTile(
                title: HybridTextField(controller: passwordController, placeholder: 'Password'),
              ),
              ListTile(
                title: HybridTextField(controller: passwordController, placeholder: 'Repeat password', readOnly: true),
              ),
              const Divider(),
              ListTile(
                title: HybridButton(
                  onPressed: () => signupCubit.signup(email: emailController.text, password: passwordController.text),
                  text: 'Sign up',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
