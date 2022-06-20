import 'package:astralnote_app/global/global_blocs.dart';
import 'package:astralnote_app/global/listeners/auth_guard.dart';
import 'package:astralnote_app/router_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return GlobalBlocs(
      child: AuthGuard(
        navigator: navigatorKey,
        child: PlatformProvider(builder: (context) {
          return PlatformApp(
            title: 'Flutter Demo',
            // theme: ThemeData(primarySwatch: Colors.blue),
            navigatorKey: navigatorKey,
            initialRoute: Routes.start.name,
            onGenerateRoute: (settings) {
              // return MaterialPageRoute(builder: (context) => RouterService().navigate(settings));
              return platformPageRoute(
                context: context,
                builder: (context) => RouterService().navigate(settings),
              );
            },
          );
        }),
      ),
    );
  }
}
