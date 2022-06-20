import 'package:astralnote_app/infrastructure/notes_local_repository.dart';
import 'package:astralnote_app/models/note/note.dart';
import 'package:astralnote_app/pages/view_note/cubit/view_note_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class ViewNotePage extends StatelessWidget {
  const ViewNotePage({required this.note, Key? key}) : super(key: key);

  final Note note;

  @override
  Widget build(BuildContext context) {
    // final contentChangeSubject = BehaviorSubject<String>();
    // contentChangeSubject.debounceTime(const Duration(seconds: 1)).listen((content) {});

    // final viewNoteCubit = context.read<ViewNoteCubit>();
    // final contentController = TextEditingController(text: note.content);
    // contentController.addListener(() => viewNoteCubit.onNoteUpdated(note, content: contentController.text));
    // contentController.addListener(() => contentChangeSubject.add(contentController.text));

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
    contentController.addListener(() => viewNoteCubit.onNoteUpdate(note, content: contentController.text));

    return PlatformScaffold(
      appBar: PlatformAppBar(
        trailingActions: [
          // PlatformIconButton(
          //   onPressed: () {},
          //   padding: EdgeInsets.zero,
          //   icon: Icon(PlatformIcons(context).ellipsis),
          // ),
          PlatformPopupMenu(
            options: [
              PopupMenuOption(
                label: 'Delete',
                onTap: (_) {
                  viewNoteCubit.onNoteDelete(id: note.id);
                  Navigator.of(context).pop();
                },
              ),
            ],
            cupertino: (_, __) => CupertinoPopupMenuData(
              cancelButtonData: CupertinoPopupMenuCancelButtonData(
                child: const Text('Cancel', style: TextStyle(color: Colors.red)),
              ),
            ),
            icon: Icon(PlatformIcons(context).ellipsis),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PlatformTextField(
            autofocus: note.content.isEmpty ? true : false,
            controller: contentController,
            maxLines: 1000,
          ),
        ),
      ),
    );
  }
}
