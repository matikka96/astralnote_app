import 'package:astralnote_app/core/ui/floating_button.dart';
import 'package:astralnote_app/core/ui/note_list_item.dart';
import 'package:astralnote_app/global/blocks/notes/notes_cubit.dart';
import 'package:astralnote_app/models/note/note.dart';
import 'package:astralnote_app/router_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notesCubit = context.watch<NotesCubit>();

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text('Astralnote'),
        leading: PlatformIconButton(
          // onPressed: () => showPlatformModalSheet(context: context, builder: (_) => const ProfilePage()),
          onPressed: () => Navigator.pushNamed(context, Routes.profile.name),
          padding: EdgeInsets.zero,
          icon: Icon(PlatformIcons(context).accountCircle),
        ),
        trailingActions: [
          PlatformIconButton(
            // onPressed: () => notesCubit.loadNotes(),
            padding: EdgeInsets.zero,
            icon: Icon(PlatformIcons(context).refresh),
          )
        ],
      ),
      body: BlocBuilder<NotesCubit, NotesState>(
        builder: (context, state) {
          if (state.isLoading) return Center(child: PlatformCircularProgressIndicator());
          if (state.isFailure != null) return const Center(child: Text('Error'));
          // if (state.notes.isEmpty) return Material(child: Center(child: PlatformText('No notes created')));

          return FloatingButton(
            onPressed: () => Navigator.pushNamed(context, Routes.note.name, arguments: Note.create()),
            child: SafeArea(
              child: state.notes.isEmpty
                  ? Center(child: PlatformText('No notes created'))
                  : ListView.separated(
                      itemCount: state.notes.length,
                      separatorBuilder: (_, __) => const Divider(height: 0),
                      itemBuilder: (context, index) => NoteListItem(note: state.notes[index]),
                    ),
            ),
          );
        },
      ),
    );
  }
}
