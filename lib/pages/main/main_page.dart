import 'package:astralnote_app/global/blocks/notes/notes_cubit.dart';
import 'package:astralnote_app/domain/note/note.dart';
import 'package:astralnote_app/router_service.dart';
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
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, Routes.profile.name),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, Routes.note.name, arguments: Note.create()),
        child: const Icon(Icons.add),
      ),
      body: const _Body(),
      // body: BlocProvider<NotesCubit>(
      //   create: (_) => NotesCubit(notesLocalRepository: NotesLocalRepository()),
      //   child: const _Body(),
      // ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesCubit, NotesState>(
      builder: (context, state) {
        if (state.isLoading) return const Center(child: CircularProgressIndicator());
        if (state.isFailure != null) return const Center(child: Text('Error'));

        final notes = state.notesLocal?.where((note) => note.status == NoteStatus.published).toList();

        if (notes == null || notes.isEmpty) {
          return const Center(child: Text('No notes created'));
        } else {
          return SafeArea(
            child: RefreshIndicator(
              onRefresh: () async => context.read<NotesCubit>().onRefreshNotes(),
              child: ListView.separated(
                itemCount: notes.length,
                separatorBuilder: (_, __) => const Divider(height: 0),
                itemBuilder: (context, index) => ListTile(
                  onLongPress: () {},
                  onTap: () => Navigator.pushNamed(context, Routes.note.name, arguments: notes[index]),
                  trailing: const Icon(Icons.more_horiz),
                  title: Text(notes[index].title, softWrap: false),
                  subtitle: notes[index].subTitle.isNotEmpty ? Text(notes[index].subTitle, softWrap: false) : null,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
