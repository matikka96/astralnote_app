import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTheme {
  CustomTheme._internal();
  static final _singleton = CustomTheme._internal();
  factory CustomTheme() => _singleton;

  // Universal theme features
  static const _primaryColor = Colors.purple;
  static const _secondaryColor = Colors.purple;
  static const _onSecondaryColor = Colors.white;
  static const _primarySwatch = _primaryColor;
  static const _splashFactory = NoSplash.splashFactory;
  static const _shadowColor = Colors.transparent;
  static const _appBarTheme = AppBarTheme(elevation: 0, scrolledUnderElevation: 5, centerTitle: true);
  static const _tooltipTheme = TooltipThemeData(triggerMode: TooltipTriggerMode.manual);
  static const _inputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(borderSide: BorderSide.none),
    isDense: true,
    filled: true,
  );
  static const _snackBarTheme = SnackBarThemeData(behavior: SnackBarBehavior.floating, shape: StadiumBorder());
  static const _floatingActionButtonTheme = FloatingActionButtonThemeData(elevation: 0, highlightElevation: 0);

  // Light theme
  static final lightTheme = ThemeData(
    primarySwatch: _primarySwatch,
    colorScheme: const ColorScheme.light().copyWith(
      primary: _primaryColor,
      secondary: _secondaryColor,
      onSecondary: _onSecondaryColor,
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
      secondary: _primaryColor,
      onSecondary: _onSecondaryColor,
    ),
    primaryColor: _primaryColor,
    splashFactory: _splashFactory,
    shadowColor: _shadowColor,
    appBarTheme: _appBarTheme.copyWith(backgroundColor: _primaryColor),
    tooltipTheme: _tooltipTheme,
    inputDecorationTheme: _inputDecorationTheme,
    snackBarTheme: _snackBarTheme,
    floatingActionButtonTheme: _floatingActionButtonTheme,
    cupertinoOverrideTheme: const CupertinoThemeData(
      primaryColor: _primaryColor,
      textTheme: CupertinoTextThemeData(primaryColor: _onSecondaryColor),
    ),
  );
}
