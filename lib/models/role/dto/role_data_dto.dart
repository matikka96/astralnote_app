import 'package:astralnote_app/models/role/role.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'role_data_dto.freezed.dart';
part 'role_data_dto.g.dart';

@freezed
class RoleDataDTO with _$RoleDataDTO {
  const factory RoleDataDTO({
    required String id,
    required String name,
  }) = _RoleDataDTO;

  const RoleDataDTO._();

  factory RoleDataDTO.fromJson(Map<String, dynamic> json) => _$RoleDataDTOFromJson(json);

  Role toDomain() {
    return Role(id: id, name: name);
  }
}
