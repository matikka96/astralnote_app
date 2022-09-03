import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_info.freezed.dart';

@freezed
class AppInfo with _$AppInfo {
  const factory AppInfo({
    required int id,
    required int version,
    required String termsOfUse,
    required String privacyPolicy,
  }) = _AppInfo;
}
