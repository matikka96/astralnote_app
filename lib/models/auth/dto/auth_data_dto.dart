import 'package:astralnote_app/models/auth/auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_data_dto.freezed.dart';
part 'auth_data_dto.g.dart';

@freezed
class AuthDataDTO with _$AuthDataDTO {
  const factory AuthDataDTO({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'expires') required int expires,
    @JsonKey(name: 'refresh_token') required String refreshToken,
  }) = _AuthDataDTO;

  const AuthDataDTO._();

  factory AuthDataDTO.fromJson(Map<String, dynamic> json) => _$AuthDataDTOFromJson(json);

  Auth toDomain() {
    return Auth(
      accessToken: accessToken,
      expires: expires,
      refreshToken: refreshToken,
    );
  }
}
