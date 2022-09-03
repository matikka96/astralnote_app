import 'package:astralnote_app/global/blocks/lifecycle/lifecycle_cubit.dart';
import 'package:astralnote_app/global/blocks/remote_config/remote_config_cubit.dart';
import 'package:astralnote_app/global/blocks/user/user_cubit.dart';
import 'package:astralnote_app/router_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserListener extends StatelessWidget {
  const UserListener({
    required this.child,
    required this.navigatorKey,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listenWhen: (previous, current) => previous.user != current.user,
      listener: (context, state) {
        // Check if user has accepted latest App Info (terms of use & privacy policy)
        if (context.read<LifecycleCubit>().state.isOnlineAndActiveAndAuthenticated) {
          final userAcceptedAppInfoId = state.user?.acceptedAppInfoId;
          final latestAppInfoId = context.read<RemoteConfigCubit>().state.remoteConfig?.info.id;
          if (userAcceptedAppInfoId != latestAppInfoId && latestAppInfoId != null) {
            navigatorKey.currentState?.pushNamed(Routes.termsOfUse.name);
          }
        }
      },
      child: child,
    );
  }
}
