part of 'local_config_cubit.dart';

@freezed
class LocalConfigState with _$LocalConfigState {
  const factory LocalConfigState({
    required NotesSortOrder sortOrder,
    required AppTheme theme,
  }) = _LocalConfigState;

  const LocalConfigState._();

  factory LocalConfigState.initial() {
    return const LocalConfigState(sortOrder: NotesSortOrder.dateEdited, theme: AppTheme.system);
  }

  ThemeMode get activeTheme {
    var themeMode = ThemeMode.system;
    if (theme == AppTheme.light) themeMode = ThemeMode.light;
    if (theme == AppTheme.dark) themeMode = ThemeMode.dark;
    return themeMode;
  }
}
