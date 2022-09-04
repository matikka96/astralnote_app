import 'package:astralnote_app/domain/note/note.dart';
import 'package:astralnote_app/pages/account_created/account_created_page.dart';
import 'package:astralnote_app/pages/deleted_notes/deleted_notes_page.dart';
import 'package:astralnote_app/pages/initial/initial_page.dart';
import 'package:astralnote_app/pages/login/login_page.dart';
import 'package:astralnote_app/pages/main/main_page.dart';
import 'package:astralnote_app/pages/profile/profile_page.dart';
import 'package:astralnote_app/pages/signup/signup_page.dart';
import 'package:astralnote_app/pages/start/start_page.dart';
import 'package:astralnote_app/pages/terms_of_use/terms_of_use_page.dart';
import 'package:astralnote_app/pages/webview/webview_page.dart';
import 'package:flutter/material.dart';

import 'pages/view_note/view_note_page.dart';

enum Routes {
  initial('/initial'),
  termsOfUse('/terms-of-use'),
  profile('/profile'),
  deletedNotes('/deleted-notes'),
  accountCreated('/account-created'),
  webview('/webview'),
  login('/login'),
  signup('/signup'),
  viewNote('/note'),
  main('/main'),
  start('/');

  const Routes(this.name);
  final String name;
}

class RouterService {
  RouterService._internal();
  static final _singleton = RouterService._internal();
  factory RouterService() => _singleton;

  PageRouteBuilder _fadePageBuilder(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
      pageBuilder: ((context, animation, secondaryAnimation) => page),
    );
  }

  navigate(RouteSettings settings) {
    final route = Routes.values.firstWhere((route) => route.name == settings.name);
    switch (route) {
      case Routes.initial:
        return MaterialPageRoute(builder: (_) => const InitialPage());
      case Routes.profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case Routes.deletedNotes:
        return MaterialPageRoute(builder: (_) => const DeletedNotesPage());
      case Routes.accountCreated:
        return MaterialPageRoute(builder: (_) => const AccountCreatedPage());
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case Routes.signup:
        return MaterialPageRoute(builder: (_) => const SignupPage());
      case Routes.viewNote:
        final noteData = settings.arguments as Note;
        return MaterialPageRoute(builder: (_) => ViewNotePage(note: noteData));
      case Routes.main:
        return _fadePageBuilder(const MainPage());
      case Routes.start:
        return _fadePageBuilder(const StartPage());
      case Routes.webview:
        final pageParams = settings.arguments as WebviewPageParams;
        return MaterialPageRoute(builder: (_) => WebviewPage(params: pageParams));
      case Routes.termsOfUse:
        return MaterialPageRoute(builder: (_) => const TermsOfUsePage(), fullscreenDialog: true);
    }
  }
}
