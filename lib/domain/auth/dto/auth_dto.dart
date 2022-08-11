import 'package:astralnote_app/domain/auth/auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_dto.freezed.dart';
part 'auth_dto.g.dart';

@freezed
class AuthDTO with _$AuthDTO {
  const factory AuthDTO({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'expires') required int expires,
    @JsonKey(name: 'refresh_token') required String refreshToken,
  }) = _AuthDTO;

  const AuthDTO._();

  factory AuthDTO.fromJson(Map<String, dynamic> json) => _$AuthDTOFromJson(json);

  Auth toDomain() {
    return Auth(
      accessToken: accessToken,
      expires: expires,
      refreshToken: refreshToken,
    );
  }
}
