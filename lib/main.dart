import 'package:astralnote_app/core/custom_theme.dart';
import 'package:astralnote_app/global/blocks/local_config/local_config_cubit.dart';
import 'package:astralnote_app/global/global_blocs.dart';
import 'package:astralnote_app/global/global_listeners.dart';
import 'package:astralnote_app/global/global_repositories.dart';
import 'package:astralnote_app/router_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final _routerService = RouterService();

  @override
  Widget build(BuildContext context) {
    return GlobalRepositories(
      child: GlobalBlocs(
        child: GlobalListeners(
          navigatorKey: navigatorKey,
          child: BlocBuilder<LocalConfigCubit, LocalConfigState>(
            buildWhen: (previous, current) => previous.theme != current.theme,
            builder: (context, state) {
              return MaterialApp(
                title: 'Flutter Demo',
                theme: CustomTheme.lightTheme,
                darkTheme: CustomTheme.darkTheme,
                themeMode: state.activeTheme,
                navigatorKey: navigatorKey,
                initialRoute: Routes.start.name,
                onGenerateRoute: (settings) => _routerService.navigate(settings),
              );
            },
          ),
        ),
      ),
    );
  }
}
