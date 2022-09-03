part of 'remote_config_cubit.dart';

@freezed
class RemoteConfigState with _$RemoteConfigState {
  const factory RemoteConfigState({
    required RemoteConfig? remoteConfig,
  }) = _RemoteConfigState;

  const RemoteConfigState._();

  factory RemoteConfigState.initial() {
    return const RemoteConfigState(remoteConfig: null);
  }

  String? get termsOfUse => remoteConfig?.info.termsOfUse;

  String? get privacyPolicy => remoteConfig?.info.privacyPolicy;

  String get appVersion {
    if (remoteConfig != null) {
      final major = remoteConfig!.currentRelease.major;
      final minor = remoteConfig!.currentRelease.minor;
      final patch = remoteConfig!.currentRelease.patch;
      return '$major.$minor.$patch';
    } else {
      return '-';
    }
  }
}
