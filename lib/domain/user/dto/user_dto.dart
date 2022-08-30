import 'package:astralnote_app/domain/user/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
class UserDTO with _$UserDTO {
  const factory UserDTO({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'first_name') required String? firstName,
    @JsonKey(name: 'last_name') required String? lastName,
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'password') required String? password,
    @JsonKey(name: 'location') required String? location,
    @JsonKey(name: 'title') required String? title,
    @JsonKey(name: 'description') required String? description,
    @JsonKey(name: 'tags') required String? tags,
    @JsonKey(name: 'avatar') required String? avatar,
    @JsonKey(name: 'language') required String? language,
    @JsonKey(name: 'theme') required String? theme,
    @JsonKey(name: 'tfa_secret') required String? tfaSecret,
    @JsonKey(name: 'status') required String status,
    @JsonKey(name: 'role') required String role,
    @JsonKey(name: 'token') required String? token,
    @JsonKey(name: 'last_access') required String lastAccess,
    @JsonKey(name: 'last_page') required String? lastPage,
    @JsonKey(name: 'provider') required String provider,
    @JsonKey(name: 'external_identifier') required String? externalIdentifier,
    @JsonKey(name: 'auth_data') required String? authData,
    @JsonKey(name: 'email_notifications') required bool? emailNotifications,
  }) = _UserDTO;

  const UserDTO._();

  factory UserDTO.fromJson(Map<String, dynamic> json) => _$UserDTOFromJson(json);

  User toDomain() {
    return User(
      id: id,
      email: email,
    );
  }
}
