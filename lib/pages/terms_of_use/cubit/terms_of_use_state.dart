part of 'terms_of_use_cubit.dart';

enum TermsOfUseStatus { idle, inProgress, success, failed }

@freezed
class TermsOfUseState with _$TermsOfUseState {
  const factory TermsOfUseState({
    required bool termsOfUseAccepted,
    required bool privacyPolicyAccepted,
    required TermsOfUseStatus status,
  }) = _TermsOfUseState;

  factory TermsOfUseState.initial() {
    return const TermsOfUseState(
      termsOfUseAccepted: false,
      privacyPolicyAccepted: false,
      status: TermsOfUseStatus.idle,
    );
  }
}
