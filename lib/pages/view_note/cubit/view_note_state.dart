part of 'view_note_cubit.dart';

@freezed
class ViewNoteState with _$ViewNoteState {
  const factory ViewNoteState({
    required Note? editingNote,
    NotesLocalFailure? failure,
  }) = _ViewNoteState;
}
