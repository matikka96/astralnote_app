import 'package:astralnote_app/domain/remote_config/app_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_info_dto.freezed.dart';
part 'app_info_dto.g.dart';

@freezed
class AppInfoDTO with _$AppInfoDTO {
  const factory AppInfoDTO({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'version') required int version,
    @JsonKey(name: 'terms_of_use') required String termsOfUse,
    @JsonKey(name: 'privacy_policy') required String privacyPolicy,
  }) = _AppInfoDTO;

  const AppInfoDTO._();

  factory AppInfoDTO.fromJson(Map<String, dynamic> json) => _$AppInfoDTOFromJson(json);

  AppInfo toDomain() {
    return AppInfo(
      id: id,
      version: version,
      termsOfUse: termsOfUse,
      privacyPolicy: privacyPolicy,
    );
  }
}
