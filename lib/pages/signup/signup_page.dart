import 'package:astralnote_app/core/extensions/extensions.dart';
import 'package:astralnote_app/core/ui/custom_divider.dart';
import 'package:astralnote_app/core/ui/custom_layout.dart';
import 'package:astralnote_app/core/ui/hybrid_button.dart';
import 'package:astralnote_app/core/ui/hybrid_text_field.dart';
import 'package:astralnote_app/infrastructure/auth_repository.dart';
import 'package:astralnote_app/pages/signup/cubit/signup_cubit.dart';
import 'package:astralnote_app/router_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(authRepository: context.read<AuthRepository>()),
      child: BlocListener<SignupCubit, SignupState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          switch (state.status) {
            case SingupStatus.success:
              context.navigator.pushReplacementNamed(Routes.accountCreated.name);
              break;
            case SingupStatus.userAlreadyExist:
              context.showSnackbarMessage('User with the email already exists');
              break;
            default:
              context.showSnackbarMessage('Unexpected error happened');
          }
        },
        child: const _SignupForm(),
      ),
    );
  }
}

class _SignupForm extends StatelessWidget {
  const _SignupForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final signupCubit = context.read<SignupCubit>();
    final emailController = TextEditingController(text: signupCubit.state.email);
    final passwordController = TextEditingController(text: signupCubit.state.password);
    final passwordRepeatedController = TextEditingController(text: signupCubit.state.passwordRepeated);

    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        emailController.addListener(() => signupCubit.onUpdateEmailField(emailController.text));
        passwordController.addListener(() => signupCubit.onUpdatePasswordField(passwordController.text));
        passwordRepeatedController
            .addListener(() => signupCubit.onUpdatePasswordRepeatedField(passwordRepeatedController.text));

        return Scaffold(
          appBar: AppBar(title: const Text('Sign up')),
          body: CustomLayout.scrollable(
            bottomWidgets: [
              const CustomDivider(showTopPadding: false),
              HybridButton(
                onPressed: state.allFieldsAreValid
                    ? () => signupCubit.onSignup(email: emailController.text, password: passwordController.text)
                    : null,
                text: 'Sign up',
              ),
              const CustomDivider(showBottomPadding: false, showBorder: false),
            ],
            child: Column(
              children: [
                const SizedBox(height: 10),
                HybridTextField(
                  controller: emailController,
                  inputType: TextInputType.emailAddress,
                  placeholder: 'Email',
                ),
                HybridTextField(
                  controller: passwordController,
                  placeholder: 'Password',
                  isForPassword: true,
                ),
                HybridTextField(
                  controller: passwordRepeatedController,
                  placeholder: 'Repeat password',
                  isForPassword: true,
                ),
                CustomDivider.emptySmall(),
                _FieldValidation(text: 'Email is valid', isValid: state.emailIsOK),
                _FieldValidation(text: 'Password is at least 6 characters', isValid: state.passwordIsOk),
                _FieldValidation(text: 'Password is repeated correctly', isValid: state.passwordsAreMatching),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FieldValidation extends StatelessWidget {
  const _FieldValidation({
    required this.text,
    required this.isValid,
    Key? key,
  }) : super(key: key);

  final String text;
  final bool? isValid;

  @override
  Widget build(BuildContext context) {
    final iconColor = isValid == null
        ? Colors.grey
        : isValid!
            ? Colors.green
            : Colors.red;

    return ListTile(
      dense: true,
      title: Row(
        children: [
          Icon(Icons.check_circle, color: iconColor),
          const SizedBox(width: 10),
          Flexible(child: Text(text)),
        ],
      ),
    );
  }
}
