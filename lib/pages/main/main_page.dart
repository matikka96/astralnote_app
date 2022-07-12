import 'package:astralnote_app/global/blocks/notes/notes_cubit.dart';
import 'package:astralnote_app/infrastructure/notes_local_repository.dart';
import 'package:astralnote_app/models/note/note.dart';
import 'package:astralnote_app/router_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: BlocProvider<NotesCubit>(
        create: (_) => NotesCubit(notesLocalRepository: NotesLocalRepository()),
        child: const _Body(),
      ),
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

        return SafeArea(
          child: state.notes.isEmpty
              ? const Center(child: Text('No notes created'))
              : RefreshIndicator(
                  onRefresh: () async => print('refresh'),
                  child: ListView.separated(
                    itemCount: state.notes.length,
                    separatorBuilder: (_, __) => const Divider(height: 0),
                    itemBuilder: (context, index) => ListTile(
                      onLongPress: () {},
                      onTap: () => Navigator.pushNamed(context, Routes.note.name, arguments: state.notes[index]),
                      trailing: const Icon(Icons.add),
                      title: Text(state.notes[index].title, softWrap: false),
                      subtitle: state.notes[index].subTitle.isNotEmpty
                          ? Text(state.notes[index].subTitle, softWrap: false)
                          : null,
                    ),
                  ),
                ),
        );
      },
    );
  }
}
