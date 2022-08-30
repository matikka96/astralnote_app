import 'package:astralnote_app/core/extensions/extensions.dart';
import 'package:astralnote_app/core/ui/action_menu/action_menu.dart';
import 'package:astralnote_app/core/ui/action_menu/action_menu_item.dart';
import 'package:astralnote_app/core/ui/custom_list.dart';
import 'package:astralnote_app/core/ui/hybrid_dialog.dart';
import 'package:astralnote_app/core/ui/hybrid_scroll_bar.dart';
import 'package:astralnote_app/domain/local_config/app_theme.dart';
import 'package:astralnote_app/domain/local_config/note_sort_order.dart';
import 'package:astralnote_app/global/blocks/auth/auth_cubit.dart';
import 'package:astralnote_app/global/blocks/local_config/local_config_cubit.dart';
import 'package:astralnote_app/global/blocks/notes/notes_cubit.dart';
import 'package:astralnote_app/global/blocks/user/user_cubit.dart';
import 'package:astralnote_app/infrastructure/user_repository.dart';
import 'package:astralnote_app/router_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () => showActionMenu(
              context,
              actionMenu: ActionMenu(
                title: 'Dev tools',
                actionItems: [
                  // TODO: Show only in dev mode
                  ActionMenuItem(onPress: () => context.read<AuthCubit>().onBreakAccess(), description: 'Break access'),
                  ActionMenuItem(onPress: () => context.read<AuthCubit>().onPrintTokens(), description: 'Print tokens'),
                ],
              ),
            ),
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => UserCubit(userRepository: context.read<UserRepository>()),
        child: HybridScrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const _DeletedNotes(),
                const _Preferences(),
                const _Information(),
                const _Account(),
                SizedBox(height: context.safeAreaPadding.bottom),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DeletedNotes extends StatelessWidget {
  const _DeletedNotes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesCubit, NotesState>(
      builder: (context, state) {
        return CustomListGroup(
          title: 'Deleted notes',
          listItems: [
            CustomListItem(
              onTap: () => state.notesRemoved.isNotEmpty ? context.navigator.pushNamed(Routes.deletedNotes.name) : null,
              title: '${state.notesRemoved.length} notes in bin',
              subtitle: 'Notes are peranently deleted after 30 days',
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          ],
        );
      },
    );
  }
}

class _Preferences extends StatelessWidget {
  const _Preferences({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localConfigCubit = context.read<LocalConfigCubit>();

    final List<SortOrderOption> sortOptions = [
      SortOrderOption(name: 'Date edited', order: NotesSortOrder.dateEdited),
      SortOrderOption(name: 'Date created', order: NotesSortOrder.dateCreated),
      SortOrderOption(name: 'Title', order: NotesSortOrder.title),
    ];

    final List<AppThemeOption> appThemeOptions = [
      AppThemeOption(name: 'System', theme: AppTheme.system),
      AppThemeOption(name: 'Light', theme: AppTheme.light),
      AppThemeOption(name: 'Dark', theme: AppTheme.dark),
    ];

    return BlocBuilder<LocalConfigCubit, LocalConfigState>(
      builder: (context, state) {
        return CustomListGroup(
          title: 'Preferences',
          listItems: [
            CustomListItem(
              onTap: () => showActionMenu(
                context,
                actionMenu: ActionMenu(
                  title: 'Sort order',
                  actionItems: [
                    for (var option in sortOptions)
                      ActionMenuItem(
                        description: option.name,
                        onPress: () => localConfigCubit.onUpdatedSortOrder(option.order),
                      ),
                  ],
                ),
              ),
              title: 'Sort order',
              subtitle: sortOptions.firstWhere((option) => option.order == state.sortOrder).name,
            ),
            CustomListItem(
              onTap: () => showActionMenu(
                context,
                actionMenu: ActionMenu(
                  title: 'Theme',
                  actionItems: [
                    for (var option in appThemeOptions)
                      ActionMenuItem(
                        description: option.name,
                        onPress: () => localConfigCubit.onUpdatedTheme(option.theme),
                      ),
                  ],
                ),
              ),
              title: 'Theme',
              subtitle: appThemeOptions.firstWhere((option) => option.theme == state.theme).name,
            ),
          ],
        );
      },
    );
  }
}

// TODO: Get links dynamically
class _Information extends StatelessWidget {
  const _Information({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomListGroup(
      title: 'Information',
      listItems: [
        CustomListItem.link(context, title: 'Terms of Use', url: 'https://matvei.xyz'),
        CustomListItem.link(context, title: 'Privacy Policy', url: 'https://google.com'),
      ],
    );
  }
}

class _Account extends StatelessWidget {
  const _Account({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case UserStatus.loadingFailed:
            context.showSnackbarMessage('Failed to load user data');
            break;
          case UserStatus.userDeletionFailed:
            context.showSnackbarMessage('Failed to delete user');
            break;
          case UserStatus.userDeleted:
            context.read<AuthCubit>().onLogout();
            break;
          default:
        }
      },
      buildWhen: (previous, current) => previous.user.email != current.user.email,
      builder: (context, state) {
        return CustomListGroup(
          title: 'Account',
          listItems: [
            CustomListItem(title: 'Email', subtitle: state.user.email),
            CustomListItem(
              onTap: state.status == UserStatus.loaded
                  ? () => showHybridDialog(context,
                      content: HybridDialog(
                        title: 'All your notes will be permanently deleted',
                        onAccept: () => context.read<UserCubit>().onDelete(),
                      ))
                  : null,
              title: 'Delete account',
            ),
            CustomListItem(
              onTap: state.status == UserStatus.loaded ? () => context.read<AuthCubit>().onLogout() : null,
              title: 'Logout',
              color: Colors.red,
            ),
          ],
        );
      },
    );
  }
}
