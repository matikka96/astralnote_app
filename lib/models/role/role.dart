import 'package:freezed_annotation/freezed_annotation.dart';

part 'role.freezed.dart';

@freezed
class Role with _$Role {
  const factory Role({
    required String id,
    required String name,
  }) = _Role;

  const Role._();
}
