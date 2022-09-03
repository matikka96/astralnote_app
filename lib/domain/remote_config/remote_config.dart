import 'package:astralnote_app/domain/remote_config/app_info.dart';
import 'package:astralnote_app/domain/remote_config/app_release.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_config.freezed.dart';

@freezed
class RemoteConfig with _$RemoteConfig {
  const factory RemoteConfig({
    required int id,
    required AppRelease currentRelease,
    required AppRelease minRelease,
    required AppInfo info,
  }) = _RemoteConfig;
}
