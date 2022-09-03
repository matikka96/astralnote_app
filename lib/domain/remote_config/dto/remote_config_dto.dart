import 'package:astralnote_app/domain/remote_config/dto/app_info_dto.dart';
import 'package:astralnote_app/domain/remote_config/dto/app_release_dto.dart';
import 'package:astralnote_app/domain/remote_config/remote_config.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_config_dto.freezed.dart';
part 'remote_config_dto.g.dart';

@freezed
class RemoteConfigDTO with _$RemoteConfigDTO {
  const factory RemoteConfigDTO({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'current_release') required AppReleaseDTO currentReleaseDTO,
    @JsonKey(name: 'min_release') required AppReleaseDTO minReleaseDTO,
    @JsonKey(name: 'info') required AppInfoDTO infoDTO,
  }) = _RemoteConfigDTO;

  const RemoteConfigDTO._();

  factory RemoteConfigDTO.fromJson(Map<String, dynamic> json) => _$RemoteConfigDTOFromJson(json);

  RemoteConfig toDomain() {
    return RemoteConfig(
      id: id,
      currentRelease: currentReleaseDTO.toDomain(),
      minRelease: minReleaseDTO.toDomain(),
      info: infoDTO.toDomain(),
    );
  }
}
