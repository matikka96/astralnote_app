import 'package:astralnote_app/domain/remote_config/remote_config.dart';
import 'package:astralnote_app/infrastructure/remote_config_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_config_state.dart';
part 'remote_config_cubit.freezed.dart';

class RemoteConfigCubit extends Cubit<RemoteConfigState> {
  RemoteConfigCubit({
    required RemoteConfigRepository remoteConfigRepository,
  })  : _remoteConfigRepository = remoteConfigRepository,
        super(RemoteConfigState.initial());

  final RemoteConfigRepository _remoteConfigRepository;

  Future<void> onLoadRemoteConfig() async {
    if (state.remoteConfig == null) {
      final failureOrRemoteConfig = await _remoteConfigRepository.getRemoteConfig();
      failureOrRemoteConfig.fold(
        (error) => emit(RemoteConfigState.initial()),
        (remoteConfig) => emit(state.copyWith(remoteConfig: remoteConfig)),
      );
    }
  }

  void onDispose() {
    emit(RemoteConfigState.initial());
  }
}
