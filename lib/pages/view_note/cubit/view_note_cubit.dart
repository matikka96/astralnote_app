import 'package:astralnote_app/infrastructure/notes_local_repository.dart';
import 'package:astralnote_app/models/note/note.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'view_note_state.dart';
part 'view_note_cubit.freezed.dart';

class ViewNoteCubit extends Cubit<ViewNoteState> {
  ViewNoteCubit({
    required NotesLocalRepository notesLocalRepository,
  })  : _notesLocalRepository = notesLocalRepository,
        super(const ViewNoteState.uninitialized());

  final NotesLocalRepository _notesLocalRepository;

  onInit({required Note note}) => emit(ViewNoteState.initialized(note: note));

  onNoteUpdate(Note note, {required String content}) {
    // final updatedNote = note.copyWith(content: content);
    final resultNote = _notesLocalRepository.updateNote(note, updatedContent: content);
    emit(ViewNoteState.initialized(note: resultNote));
  }

  onNoteDelete({required String id}) {
    _notesLocalRepository.deleteNote(noteID: id);
  }
}
