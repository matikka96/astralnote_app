import 'package:astralnote_app/models/role/dto/role_data_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'role_dto.freezed.dart';
part 'role_dto.g.dart';

@freezed
class RoleDTO with _$RoleDTO {
  const factory RoleDTO({
    required List<RoleDataDTO> data,
  }) = _RoleDTO;

  factory RoleDTO.fromJson(Map<String, dynamic> json) => _$RoleDTOFromJson(json);
}
