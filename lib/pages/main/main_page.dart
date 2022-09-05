import 'package:astralnote_app/core/extensions/extensions.dart';
import 'package:astralnote_app/core/ui/custom_divider.dart';
import 'package:astralnote_app/core/ui/custom_list.dart';
import 'package:astralnote_app/core/ui/hybrid_scroll_bar.dart';
import 'package:astralnote_app/core/ui/hybrid_search_field.dart';
import 'package:astralnote_app/global/blocks/lifecycle/lifecycle_cubit.dart';
import 'package:astralnote_app/global/blocks/notes/notes_cubit.dart';
import 'package:astralnote_app/domain/note/note.dart';
import 'package:astralnote_app/router_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotesCubit, NotesState>(
      listenWhen: (previous, current) => !previous.isSyncing && current.isSyncing,
      listener: (_, state) => context.showSnackbarCustom(content: const LinearProgressIndicator()),
      child: GestureDetector(
        onPanDown: (_) => context.hideKeyboard,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: const Text('Astralnote'),
            leading: IconButton(
              onPressed: () => Navigator.pushNamed(context, Routes.profile.name),
              icon: const Icon(Icons.account_circle),
            ),
            actions: [
              IconButton(
                onPressed: () => context.showSnackbarMessage('Test message'),
                icon: const Icon(Icons.sort),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, Routes.viewNote.name, arguments: Note.create()),
            child: const Icon(Icons.add),
          ),
          body: const _Body(),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController(text: '');
    searchController.addListener(() => context.read<NotesCubit>().onUpdateSearchQuery(searchController.text));

    return BlocBuilder<NotesCubit, NotesState>(
      // buildWhen: (previous, current) => previous.notesPublished != current.notesPublished,
      builder: (context, state) {
        print(state.status);
        // if (state.isInitialLoading) return const Center(child: CircularProgressIndicator());
        if (state.notesPublished.isEmpty) return const Center(child: Text('No notes created'));

        final notes = state.publishedAndSorted;
        return SafeArea(
          child: RefreshIndicator(
            color: context.theme.colorScheme.secondary,
            onRefresh: () async {
              HapticFeedback.selectionClick();
              if (context.read<LifecycleCubit>().state.appIsOnline) {
                await context.read<NotesCubit>().onRefreshNotesRemote();
              } else {
                context.showSnackbarMessage('You\'re offline. Try again later.');
              }
            },
            child: HybridScrollbar(
              child: CustomScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        HybridSearchField(controller: searchController),
                        if (state.publishedAndSorted.isEmpty)
                          ListTile(
                            title: Text(
                              'No search results with "${searchController.text}"',
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Column(
                        children: [
                          CustomDivider.list(),
                          CustomListItem.note(context, note: notes[index]),
                        ],
                      ),
                      childCount: notes.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
