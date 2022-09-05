import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTheme {
  CustomTheme._internal();
  static final _singleton = CustomTheme._internal();
  factory CustomTheme() => _singleton;

  // Universal theme features
  static const _primaryColor = Colors.deepPurple;
  static const _secondaryColor = Colors.purpleAccent;
  static const _onPrimaryColor = Colors.white;
  static const _splashFactory = NoSplash.splashFactory;
  static const _shadowColor = Colors.transparent;
  static const _appBarTheme = AppBarTheme(elevation: 0, scrolledUnderElevation: 5, centerTitle: true);
  static const _tooltipTheme = TooltipThemeData(triggerMode: TooltipTriggerMode.manual);
  static const _inputDecorationTheme = InputDecorationTheme(
    labelStyle: TextStyle(),
    border: OutlineInputBorder(borderSide: BorderSide.none),
    isDense: true,
    filled: true,
  );
  static const _snackBarTheme = SnackBarThemeData(behavior: SnackBarBehavior.floating, shape: StadiumBorder());
  static const _floatingActionButtonTheme = FloatingActionButtonThemeData(
    elevation: 0,
    highlightElevation: 0,
    backgroundColor: _primaryColor,
    foregroundColor: _onPrimaryColor,
  );

  // Light theme
  static final lightTheme = ThemeData(
    primarySwatch: _primaryColor,
    colorScheme: const ColorScheme.light().copyWith(
      primary: _primaryColor,
      secondary: _primaryColor,
      onPrimary: _onPrimaryColor,
      onSecondary: _onPrimaryColor,
    ),
    splashFactory: _splashFactory,
    shadowColor: _shadowColor,
    appBarTheme: _appBarTheme,
    tooltipTheme: _tooltipTheme,
    inputDecorationTheme: _inputDecorationTheme,
    snackBarTheme: _snackBarTheme,
    floatingActionButtonTheme: _floatingActionButtonTheme,
  );

  // Dark theme
  static final darkTheme = ThemeData.dark().copyWith(
    colorScheme: const ColorScheme.dark().copyWith(
      primary: _primaryColor,
      secondary: _secondaryColor,
      onPrimary: _onPrimaryColor,
    ),
    scaffoldBackgroundColor: Colors.black,
    primaryColor: _primaryColor,
    splashFactory: _splashFactory,
    shadowColor: _shadowColor,
    dividerColor: const Color(0x66BCBCBC),
    appBarTheme: _appBarTheme.copyWith(backgroundColor: _primaryColor),
    tooltipTheme: _tooltipTheme,
    inputDecorationTheme: _inputDecorationTheme,
    snackBarTheme: _snackBarTheme,
    floatingActionButtonTheme: _floatingActionButtonTheme,
    textSelectionTheme: const TextSelectionThemeData(cursorColor: _secondaryColor),
    progressIndicatorTheme: const ProgressIndicatorThemeData(linearTrackColor: _secondaryColor),
    cupertinoOverrideTheme: const CupertinoThemeData(
      primaryColor: _secondaryColor,
      textTheme: CupertinoTextThemeData(primaryColor: _onPrimaryColor),
    ),
  );
}
