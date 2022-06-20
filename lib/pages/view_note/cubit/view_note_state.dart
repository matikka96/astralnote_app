part of 'view_note_cubit.dart';

@freezed
class ViewNoteState with _$ViewNoteState {
  const factory ViewNoteState.uninitialized() = _Uninitialized;
  const factory ViewNoteState.initialized({required Note note}) = _Initialized;

  // const factory ViewNoteState.idle() = _Idle;
  const factory ViewNoteState.failure({required NotesLocalFailure failure}) = _Failure;
}
