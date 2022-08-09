import 'package:astralnote_app/core/extensions/extensions.dart';
import 'package:astralnote_app/core/ui/action_menu/action_menu.dart';
import 'package:astralnote_app/global/blocks/notes/notes_cubit.dart';
import 'package:astralnote_app/domain/note/note.dart';
import 'package:astralnote_app/router_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Astralnote'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pushNamed(context, Routes.profile.name),
          icon: const Icon(Icons.account_circle),
        ),
        actions: [
          IconButton(
            onPressed: () => context.showSnackbarMessage('test'),
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, Routes.note.name, arguments: Note.create()),
        child: const Icon(Icons.add),
      ),
      body: const _Body(),
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
        if (state.notesParsed.isEmpty) return const Center(child: Text('No notes created'));

        final notes = state.notesFiltered.where((note) => note.status == NoteStatus.published).toList();
        return SafeArea(
          child: RefreshIndicator(
            onRefresh: () async => context.read<NotesCubit>().onRefreshNotes(),
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      ListTile(
                        title: CupertinoSearchTextField(
                          controller: searchController,
                          onSuffixTap: () {
                            searchController.clear();
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ),
                      if (notes.isEmpty)
                        ListTile(
                          title: Text('No search results with "${searchController.text}"', textAlign: TextAlign.center),
                        ),
                    ],
                  ),
                ),
                if (notes.isNotEmpty)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _ListItem(note: notes[index]),
                      childCount: notes.length,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem({
    required this.note,
    Key? key,
  }) : super(key: key);

  final Note note;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 0),
        ListTile(
          onLongPress: () async => showActionMenu(context, actionMenu: ActionMenu.noteActions(context, note: note)),
          onTap: () => Navigator.pushNamed(context, Routes.note.name, arguments: note),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [Icon(Icons.circle, size: 15)],
          ),
          title: Text(note.title, softWrap: false),
          subtitle: Text(note.subTitle, softWrap: false),
        ),
      ],
    );
  }
}
