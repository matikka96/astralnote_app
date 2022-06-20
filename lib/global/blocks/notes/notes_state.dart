part of 'notes_cubit.dart';

@freezed
class NotesState with _$NotesState {
  const factory NotesState({
    required bool isLoading,
    required bool syncActive,
    required List<Note> notes,
    NotesLocalFailure? isFailure,
  }) = _NotesState;

  factory NotesState.initial() {
    return const NotesState(
      isLoading: true,
      syncActive: false,
      notes: [],
    );
  }
}
