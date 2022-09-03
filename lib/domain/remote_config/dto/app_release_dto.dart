import 'package:astralnote_app/domain/remote_config/app_release.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_release_dto.freezed.dart';
part 'app_release_dto.g.dart';

@freezed
class AppReleaseDTO with _$AppReleaseDTO {
  const factory AppReleaseDTO({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'major') required int major,
    @JsonKey(name: 'minor') required int minor,
    @JsonKey(name: 'patch') required int patch,
    @JsonKey(name: 'release_notes') required String releaseNotes,
  }) = _AppReleaseDTO;

  const AppReleaseDTO._();

  factory AppReleaseDTO.fromJson(Map<String, dynamic> json) => _$AppReleaseDTOFromJson(json);

  AppRelease toDomain() {
    return AppRelease(
      id: id,
      major: major,
      minor: minor,
      patch: patch,
      releaseNotes: releaseNotes,
    );
  }
}
