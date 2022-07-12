import 'package:astralnote_app/global/global_blocs.dart';
import 'package:astralnote_app/global/listeners/auth_guard.dart';
import 'package:astralnote_app/router_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // TODO: Move theme object before build method in production
    final theme = ThemeData(
      primarySwatch: Colors.blue,
      splashFactory: NoSplash.splashFactory,
      shadowColor: Colors.transparent,
      appBarTheme: const AppBarTheme(elevation: 0),
      inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder(), isDense: true),
    );

    return GlobalBlocs(
      child: AuthGuard(
        navigator: navigatorKey,
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: theme,
          navigatorKey: navigatorKey,
          initialRoute: Routes.start.name,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(builder: (context) => RouterService().navigate(settings));
          },
        ),
      ),
    );
  }
}
