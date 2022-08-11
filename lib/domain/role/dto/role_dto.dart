import 'package:astralnote_app/domain/role/role.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'role_dto.freezed.dart';
part 'role_dto.g.dart';

@freezed
class RoleDTO with _$RoleDTO {
  const factory RoleDTO({
    required String id,
    required String name,
  }) = _RoleDTO;

  const RoleDTO._();

  factory RoleDTO.fromJson(Map<String, dynamic> json) => _$RoleDTOFromJson(json);

  Role toDomain() {
    return Role(id: id, name: name);
  }
}
