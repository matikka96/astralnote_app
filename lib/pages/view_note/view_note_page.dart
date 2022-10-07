import 'package:astralnote_app/core/ui/action_menu/action_menu.dart';
import 'package:astralnote_app/domain/note/note.dart';
import 'package:astralnote_app/infrastructure/notes_local_repository.dart';
import 'package:astralnote_app/pages/view_note/cubit/view_note_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewNotePage extends StatelessWidget {
  const ViewNotePage({required this.note, Key? key}) : super(key: key);

  final Note note;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ViewNoteCubit(notesLocalRepository: context.read<NotesLocalRepository>())..onInit(note: note),
      child: _Body(note: note),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.note,
    Key? key,
  }) : super(key: key);

  final Note note;

  @override
  Widget build(BuildContext context) {
    final viewNoteCubit = context.read<ViewNoteCubit>();
    final contentController = TextEditingController(text: note.content);
    contentController.addListener(() {
      viewNoteCubit.onNoteUpdate(note, updatedContent: contentController.text);
    });

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async => showActionMenu(
              context,
              actionMenu: note.status == NoteStatus.published
                  ? ActionMenu.noteActions(context, note: note)
                  : ActionMenu.deletedNoteActions(context, note: note, popRoute: true),
            ),
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),
      body: SafeArea(
        child: TextField(
          controller: contentController,
          readOnly: note.status == NoteStatus.published ? false : true,
          autofocus: note.content.isEmpty ? true : false,
          maxLines: 1000,
          decoration: const InputDecoration(border: InputBorder.none, fillColor: Colors.transparent),
        ),
      ),
    );
  }
}
