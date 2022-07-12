import 'package:astralnote_app/router_service.dart';
import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: SafeArea(
        child: Column(
          children: [
            const Placeholder(),
            MaterialButton(
              onPressed: () => Navigator.of(context).pushNamed(Routes.login.name),
              child: const Text('Login', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            MaterialButton(
              onPressed: () => Navigator.of(context).pushNamed(Routes.signup.name),
              child: const Text('Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
