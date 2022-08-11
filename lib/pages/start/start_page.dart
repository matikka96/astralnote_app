import 'package:astralnote_app/core/extensions/extensions.dart';
import 'package:astralnote_app/core/ui/hybrid_button.dart';
import 'package:astralnote_app/router_service.dart';
import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(context.navigator.canPop());

    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: SafeArea(
        child: Column(
          children: [
            const Placeholder(),
            const Divider(),
            ListTile(
              title: HybridButton(
                onPressed: () => context.navigator.pushNamed(Routes.login.name),
                text: 'Login',
              ),
            ),
            ListTile(
              title: HybridButton.secondary(
                onPressed: () => context.navigator.pushNamed(Routes.signup.name),
                text: 'Sign up',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
