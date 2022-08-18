import 'package:astralnote_app/core/extensions/extensions.dart';
import 'package:astralnote_app/core/ui/action_menu/action_menu.dart';
import 'package:astralnote_app/core/ui/action_menu/action_menu_item.dart';
import 'package:astralnote_app/core/ui/custom_list.dart';
import 'package:astralnote_app/domain/local_config/app_theme.dart';
import 'package:astralnote_app/domain/local_config/note_sort_order.dart';
import 'package:astralnote_app/global/blocks/auth/auth_cubit.dart';
import 'package:astralnote_app/global/blocks/local_config/local_config_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const _Preferences(),
            CustomListGroup(
              title: 'Info',
              listItems: [
                CustomListItem.link(
                  context,
                  title: 'Terms of Use',
                  url: 'https://matvei.xyz',
                ),
                CustomListItem.link(
                  context,
                  title: 'Privacy Policy',
                  url: 'https://google.com',
                ),
              ],
            ),
            CustomListGroup(
              title: 'Dev tools',
              listItems: [
                CustomListItem(
                  onTap: () => authCubit.onBreakAccess(),
                  title: 'Break access',
                ),
                CustomListItem(
                  onTap: () => authCubit.onPrintTokens(),
                  title: 'Print tokens',
                ),
              ],
            ),
            CustomListGroup(
              title: 'Account',
              listItems: [
                const CustomListItem(
                  onTap: null,
                  title: 'Delete account',
                ),
                CustomListItem(
                  onTap: () => authCubit.onLogout(),
                  title: 'Logout',
                  color: Colors.red,
                ),
              ],
            ),
            SizedBox(height: context.safeAreaPadding.bottom),
          ],
        ),
      ),
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
