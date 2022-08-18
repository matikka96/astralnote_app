import 'package:astralnote_app/domain/local_config/app_theme.dart';
import 'package:astralnote_app/domain/local_config/note_sort_order.dart';
import 'package:astralnote_app/infrastructure/secure_storage_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'local_config_state.dart';
part 'local_config_cubit.freezed.dart';

class LocalConfigCubit extends Cubit<LocalConfigState> {
  LocalConfigCubit({
    required SecureStorageRepository secureStorageRepository,
  })  : _secureStorageRepository = secureStorageRepository,
        super(LocalConfigState.initial()) {
    _init();
  }

  final SecureStorageRepository _secureStorageRepository;

  _init() async {
    final notesSortOrderRaw = await _secureStorageRepository.getWithKey(StorageKeys.notesSortOrder);
    final appThemeRaw = await _secureStorageRepository.getWithKey(StorageKeys.appTheme);

    final notesSortOrder = NotesSortOrder.values.firstWhere(
      (sortOrder) => sortOrder.name == notesSortOrderRaw,
      orElse: () => NotesSortOrder.dateEdited,
    );

    final appTheme = AppTheme.values.firstWhere(
      (appTheme) => appTheme.name == appThemeRaw,
      orElse: () => AppTheme.system,
    );

    emit(state.copyWith(sortOrder: notesSortOrder, theme: appTheme));
  }

  Future<void> onUpdatedSortOrder(NotesSortOrder newSortOrder) async {
    await _secureStorageRepository.setWithKey(StorageKeys.notesSortOrder, newSortOrder.name);
    emit(state.copyWith(sortOrder: newSortOrder));
  }

  Future<void> onUpdatedTheme(AppTheme newAppTheme) async {
    await _secureStorageRepository.setWithKey(StorageKeys.appTheme, newAppTheme.name);
    emit(state.copyWith(theme: newAppTheme));
  }
}
