import 'package:astralnote_app/domain/note/note.dart';
import 'package:astralnote_app/pages/login/login_page.dart';
import 'package:astralnote_app/pages/main/main_page.dart';
import 'package:astralnote_app/pages/profile/profile_page.dart';
import 'package:astralnote_app/pages/signup/signup_page.dart';
import 'package:astralnote_app/pages/start/start_page.dart';
import 'package:flutter/material.dart';

import 'pages/view_note/view_note_page.dart';

enum Routes {
  profile('/profile'),
  login('/login'),
  signup('/signup'),
  note('/main/note'),
  main('/main'),
  start('/');

  const Routes(this.name);
  final String name;
}

class RouterService {
  RouterService._internal();
  static final _singleton = RouterService._internal();
  factory RouterService() => _singleton;

  navigate(RouteSettings settings) {
    final route = Routes.values.firstWhere((route) => route.name == settings.name);
    switch (route) {
      case Routes.profile:
        return const ProfilePage();
      case Routes.login:
        return const LoginPage();
      case Routes.signup:
        return const SignupPage();
      case Routes.note:
        final noteData = settings.arguments as Note;
        return ViewNotePage(note: noteData);
      case Routes.main:
        return const MainPage();
      case Routes.start:
        return const StartPage();
    }
  }
}
