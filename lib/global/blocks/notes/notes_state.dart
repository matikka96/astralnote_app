part of 'notes_cubit.dart';

@freezed
class NotesState with _$NotesState {
  const factory NotesState({
    required bool isLoading,
    required List<Note> notes,
    GenericError? failure,
  }) = _NotesState;

  factory NotesState.initial() {
    return const NotesState(
      isLoading: true,
      notes: [],
    );
  }
}
