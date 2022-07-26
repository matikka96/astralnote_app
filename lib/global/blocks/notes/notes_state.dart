part of 'notes_cubit.dart';

@freezed
class NotesState with _$NotesState {
  const factory NotesState({
    required bool isLoading,
    required bool isSyncing,
    required bool isOnline,
    required List<Note>? notesLocal,
    required List<Note>? notesRemote,
    NotesLocalFailure? isFailure,
  }) = _NotesState;

  const NotesState._();

  factory NotesState.initial() {
    return const NotesState(
      isLoading: true,
      isSyncing: false,
      isOnline: false,
      notesLocal: null,
      notesRemote: null,
    );
  }

  bool get canSync => isOnline && notesLocal != null && notesRemote != null;
}
