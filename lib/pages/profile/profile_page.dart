// ignore_for_file: deprecated_member_use

import 'package:astralnote_app/global/blocks/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text('Profile'),
        // automaticallyImplyLeading: false,
        // trailingActions: [
        //   PlatformButton(
        //     onPressed: () => Navigator.of(context).pop(),
        //     padding: EdgeInsets.zero,
        //     child: const Text('Close'),
        //   )
        // ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PlatformButton(
              onPressed: () => authCubit.deleteAccessToken(),
              child: const Text('Break access'),
            ),
            PlatformButton(
              onPressed: () => authCubit.printTokens(),
              child: const Text('Print tokens'),
            ),
            PlatformButton(
              onPressed: () => authCubit.logout(),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
