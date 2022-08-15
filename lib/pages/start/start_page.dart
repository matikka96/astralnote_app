import 'package:astralnote_app/core/extensions/extensions.dart';
import 'package:astralnote_app/core/ui/custom_divider.dart';
import 'package:astralnote_app/core/ui/custom_layout.dart';
import 'package:astralnote_app/core/ui/hybrid_button.dart';
import 'package:astralnote_app/router_service.dart';
import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Create a widget class for slides
    final slides = [
      ColoredBox(
        color: Colors.purple.shade50,
        child: const SizedBox.expand(
          child: Center(child: Text('slide 1')),
        ),
      ),
      const Center(child: Text('slide 2')),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: CustomLayout(
        bottomWidgets: [
          const CustomDivider(showTopPadding: false),
          HybridButton(
            onPressed: () => context.navigator.pushNamed(Routes.login.name),
            text: 'Login',
          ),
          HybridButton.secondary(
            onPressed: () => context.navigator.pushNamed(Routes.signup.name),
            text: 'Sign up',
          ),
          const CustomDivider(showBottomPadding: false, showBorder: false),
        ],
        child: PageView.builder(
          itemCount: slides.length,
          itemBuilder: (context, index) => slides[index],
        ),
      ),
    );
  }
}
