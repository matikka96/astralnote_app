import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_release.freezed.dart';

@freezed
class AppRelease with _$AppRelease {
  const factory AppRelease({
    required int id,
    required int major,
    required int minor,
    required int patch,
    required String releaseNotes,
  }) = _AppRelease;
}
