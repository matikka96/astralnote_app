import 'package:astralnote_app/core/extensions/extensions.dart';
import 'package:astralnote_app/core/ui/custom_divider.dart';
import 'package:astralnote_app/core/ui/custom_layout.dart';
import 'package:astralnote_app/core/ui/custom_list.dart';
import 'package:astralnote_app/core/ui/hybrid_button.dart';
import 'package:astralnote_app/global/blocks/remote_config/remote_config_cubit.dart';
import 'package:astralnote_app/global/blocks/user/user_cubit.dart';
import 'package:astralnote_app/infrastructure/user_repository.dart';
import 'package:astralnote_app/pages/terms_of_use/cubit/terms_of_use_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TermsOfUsePage extends StatelessWidget {
  const TermsOfUsePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: BlocProvider(
          create: (context) => TermsOfUseCubit(userRepository: context.read<UserRepository>()),
          child: const _Body(),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserCubit>().state.user;
    final remoteConfigState = context.read<RemoteConfigCubit>().state;

    return BlocConsumer<TermsOfUseCubit, TermsOfUseState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case TermsOfUseStatus.success:
            context.navigator.pop();
            break;
          case TermsOfUseStatus.failed:
            context.showSnackbarMessage('Something went wrong. Please try again');
            break;
          default:
        }
      },
      builder: (context, state) {
        return CustomLayout.scrollable(
          bottomWidgets: [
            const CustomDivider(showTopPadding: false),
            HybridButton(
              onPressed: state.termsOfUseAccepted && state.privacyPolicyAccepted && user != null
                  ? () => context.read<TermsOfUseCubit>().onAccept(
                        userId: user.id,
                        appInfoId: remoteConfigState.remoteConfig!.info.id.toString(),
                      )
                  : null,
              isLoading: state.status == TermsOfUseStatus.inProgress ? true : false,
              text: 'Accept',
            ),
            // TODO: Remove close button in the end
            // HybridButton.secondary(
            //   onPressed: () => context.navigator.pop(),
            //   text: 'Close',
            // ),
            CustomDivider.emptySmall(),
          ],
          child: Column(
            children: [
              CustomDivider.empty(),
              ListTile(
                title: Text(
                  user?.acceptedAppInfoId == null
                      ? 'Accept term of use and privacy policy to proceed'
                      : 'Terms of use and/or privacy policy have been updated',
                  style: context.theme.textTheme.headlineMedium,
                ),
              ),
              CustomDivider.empty(),
              ListTile(
                subtitle: Text(
                  'Astralnote respects your privacy! Please, have a closer look by tapping on the links below if you doubt ;)',
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    color: context.theme.textTheme.caption?.color,
                  ),
                ),
              ),
              CustomDivider.empty(),
              CustomListItem.switcher(
                context,
                onChanged: (newValue) => context.read<TermsOfUseCubit>().onTermsOfUseChanged(isAccepted: newValue),
                title: 'Terms of use',
                value: state.termsOfUseAccepted,
                url: remoteConfigState.termsOfUse,
              ),
              CustomListItem.switcher(
                context,
                onChanged: (newValue) => context.read<TermsOfUseCubit>().onPrivacyPolicyChanged(isAccepted: newValue),
                title: 'Privacy policy',
                value: state.privacyPolicyAccepted,
                url: remoteConfigState.privacyPolicy,
              ),
            ],
          ),
        );
      },
    );
  }
}
