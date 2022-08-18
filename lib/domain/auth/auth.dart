import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth.freezed.dart';

@freezed
class Auth with _$Auth {
  const factory Auth({
    required String accessToken,
    required int expires,
    required String refreshToken,
  }) = _Auth;

  const Auth._();
}
