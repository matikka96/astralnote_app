part of 'connectivity_cubit.dart';

@freezed
class ConnectivityState with _$ConnectivityState {
  const factory ConnectivityState.offline() = _Offline;
  const factory ConnectivityState.online() = _Online;
}
