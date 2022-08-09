part of 'notes_cubit.dart';

@freezed
class NotesState with _$NotesState {
  const factory NotesState({
    required bool isLoading,
    required bool isSyncing,
    required bool isOnline,
    required String searchQuery,
    required List<Note>? notesLocal,
    required List<Note>? notesRemote,
    required List<Note> notesParsed, // Do we need this?
    required List<Note> notesFiltered,
    NotesLocalFailure? isFailure,
  }) = _NotesState;

  const NotesState._();

  factory NotesState.initial() {
    return const NotesState(
      isLoading: true,
      isSyncing: false,
      isOnline: false,
      searchQuery: '',
      notesLocal: null,
      notesRemote: null,
      notesParsed: [],
      notesFiltered: [],
    );
  }

  bool get canSync => isOnline && notesLocal != null && notesRemote != null;

  List<Note> get notesPublished {
    return notesParsed.where((note) => note.status == NoteStatus.published).toList();
  }

  List<Note> get notesRemoved {
    return notesParsed.where((note) => note.status == NoteStatus.archived).toList();
  }
}
