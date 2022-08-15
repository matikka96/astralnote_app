import 'package:astralnote_app/global/blocks/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MaterialButton(
              onPressed: () => authCubit.onBreakAccess(),
              child: const Text('Break access'),
            ),
            MaterialButton(
              onPressed: () => authCubit.onPrintTokens(),
              child: const Text('Print tokens'),
            ),
            MaterialButton(
              onPressed: () => authCubit.onLogout(),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
