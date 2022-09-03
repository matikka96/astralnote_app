import 'package:astralnote_app/infrastructure/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'terms_of_use_state.dart';
part 'terms_of_use_cubit.freezed.dart';

class TermsOfUseCubit extends Cubit<TermsOfUseState> {
  TermsOfUseCubit({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(TermsOfUseState.initial());

  final UserRepository _userRepository;

  void onPrivacyPolicyChanged({required bool isAccepted}) {
    emit(state.copyWith(privacyPolicyAccepted: isAccepted));
  }

  void onTermsOfUseChanged({required bool isAccepted}) {
    emit(state.copyWith(termsOfUseAccepted: isAccepted));
  }

  Future<void> onAccept({required String userId, required String appInfoId}) async {
    emit(state.copyWith(status: TermsOfUseStatus.inProgress));
    final failureOrAccepted = await _userRepository.updateUserAcceptedAppInfo(userId: userId, appInfoId: appInfoId);
    failureOrAccepted.fold(
      (error) => emit(state.copyWith(status: TermsOfUseStatus.failed)),
      (_) => emit(state.copyWith(status: TermsOfUseStatus.success)),
    );
  }
}
