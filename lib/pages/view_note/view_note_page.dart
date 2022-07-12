import 'package:astralnote_app/infrastructure/notes_local_repository.dart';
import 'package:astralnote_app/models/note/note.dart';
import 'package:astralnote_app/pages/view_note/cubit/view_note_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewNotePage extends StatelessWidget {
  const ViewNotePage({required this.note, Key? key}) : super(key: key);

  final Note note;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ViewNoteCubit(notesLocalRepository: NotesLocalRepository()),
      child: _Body(note: note),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.note, Key? key}) : super(key: key);

  final Note note;

  @override
  Widget build(BuildContext context) {
    final viewNoteCubit = context.read<ViewNoteCubit>();
    final contentController = TextEditingController(text: note.content);
    contentController.addListener(() {
      viewNoteCubit.onNoteUpdate(note, content: contentController.text);
    });

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              viewNoteCubit.onNoteDelete(id: note.id);
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            autofocus: note.content.isEmpty ? true : false,
            controller: contentController,
            maxLines: 1000,
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
      ),
    );
  }
}
