import 'package:astralnote_app/router_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(title: const Text('Welcome')),
      body: SafeArea(
        child: Column(
          children: [
            const Placeholder(),
            // ignore: deprecated_member_use
            PlatformButton(
              onPressed: () => Navigator.of(context).pushNamed(Routes.login.name),
              child: const Text('Login', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            // ignore: deprecated_member_use
            PlatformButton(
              onPressed: () => Navigator.of(context).pushNamed(Routes.signup.name),
              child: const Text('Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
