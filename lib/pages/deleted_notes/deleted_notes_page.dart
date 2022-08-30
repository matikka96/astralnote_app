import 'package:astralnote_app/core/ui/custom_divider.dart';
import 'package:astralnote_app/core/ui/custom_list.dart';
import 'package:astralnote_app/core/ui/hybrid_scroll_bar.dart';
import 'package:astralnote_app/global/blocks/notes/notes_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeletedNotesPage extends StatelessWidget {
  const DeletedNotesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deleted notes'),
      ),
      body: BlocBuilder<NotesCubit, NotesState>(
        builder: (context, state) {
          final notes = state.notesRemoved;
          return HybridScrollbar(
            child: ListView.separated(
              itemCount: notes.length,
              separatorBuilder: (context, index) => CustomDivider.list(),
              itemBuilder: (context, index) => CustomListItem.note(context, note: notes[index]),
            ),
          );
        },
      ),
    );
  }
}
