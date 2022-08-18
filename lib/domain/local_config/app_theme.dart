enum AppTheme { system, light, dark }

class AppThemeOption {
  AppThemeOption({
    required this.name,
    required this.theme,
  });
  final String name;
  final AppTheme theme;
}
