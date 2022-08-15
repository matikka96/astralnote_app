import 'package:astralnote_app/core/extensions/extensions.dart';
import 'package:astralnote_app/core/ui/hybrid_button.dart';
import 'package:astralnote_app/router_service.dart';
import 'package:flutter/material.dart';

class AccountCreatedPage extends StatelessWidget {
  const AccountCreatedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 100),
            const ListTile(
              title: Text('Congratz, you now have an account', textAlign: TextAlign.center),
            ),
            HybridButton(
              onPressed: () => context.navigator.pushReplacementNamed(Routes.login.name),
              text: 'Login',
            ),
          ],
        ),
      ),
    );
  }
}
