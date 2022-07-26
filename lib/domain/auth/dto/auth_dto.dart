import 'package:astralnote_app/domain/auth/dto/auth_data_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_dto.freezed.dart';
part 'auth_dto.g.dart';

@freezed
class AuthDTO with _$AuthDTO {
  const factory AuthDTO({
    required AuthDataDTO data,
  }) = _AuthDTO;

  factory AuthDTO.fromJson(Map<String, dynamic> json) => _$AuthDTOFromJson(json);
}
