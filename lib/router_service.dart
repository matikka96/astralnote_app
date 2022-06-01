import 'package:astralnote_app/pages/login/login_page.dart';
import 'package:astralnote_app/pages/main/main_page.dart';
import 'package:astralnote_app/pages/signup/signup_page.dart';
import 'package:astralnote_app/pages/start/start_page.dart';
import 'package:flutter/material.dart';

enum Routes {
  login(name: '/login', page: LoginPage()),
  signup(name: '/signup', page: SignupPage()),
  main(name: '/main', page: MainPage()),
  start(name: '/', page: StartPage());

  const Routes({required this.name, required this.page});
  final String name;
  final StatelessWidget page;
}

class RouterService {
  RouterService._internal();
  static final _singleton = RouterService._internal();
  factory RouterService() => _singleton;

  navigate(RouteSettings settings) {
    return Routes.values.firstWhere((route) => route.name == settings.name).page;
  }
}
