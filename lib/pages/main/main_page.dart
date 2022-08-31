import 'package:astralnote_app/core/extensions/extensions.dart';
import 'package:astralnote_app/core/ui/custom_divider.dart';
import 'package:astralnote_app/core/ui/custom_list.dart';
import 'package:astralnote_app/core/ui/hybrid_scroll_bar.dart';
import 'package:astralnote_app/core/ui/hybrid_search_field.dart';
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
    return GestureDetector(
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
              onPressed: () {},
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
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController(text: '');
    searchController.addListener(() {
      context.read<NotesCubit>().onUpdateSearchQuery(searchController.text);
    });

    return BlocConsumer<NotesCubit, NotesState>(
      listenWhen: (previous, current) => !previous.isSyncing && current.isSyncing,
      listener: (_, state) => context.showSnackbarCustom(content: const LinearProgressIndicator()),
      builder: (context, state) {
        if (state.isLoading) return const Center(child: CircularProgressIndicator());
        if (state.isFailure != null) return const Center(child: Text('Error'));
        if (state.notesFiltered.isEmpty) return const Center(child: Text('No notes created'));

        final notes = state.notesPublished;

        return SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              HapticFeedback.selectionClick();
              await context.read<NotesCubit>().onRefreshNotesRemote();
            },
            child: HybridScrollbar(
              child: CustomScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        HybridSearchField(controller: searchController),
                        if (notes.isEmpty)
                          ListTile(
                            title: Text(
                              'No search results with "${searchController.text}"',
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (notes.isNotEmpty)
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
