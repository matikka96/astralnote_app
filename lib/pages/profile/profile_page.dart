import 'package:astralnote_app/global/blocks/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MaterialButton(
              onPressed: () => authCubit.deleteAccessToken(),
              child: const Text('Break access'),
            ),
            MaterialButton(
              onPressed: () => authCubit.printTokens(),
              child: const Text('Print tokens'),
            ),
            MaterialButton(
              onPressed: () => authCubit.logout(),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
