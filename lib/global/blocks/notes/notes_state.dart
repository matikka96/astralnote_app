part of 'notes_cubit.dart';

@freezed
class NotesState with _$NotesState {
  const factory NotesState({
    required bool isLoading,
    required bool isSyncing,
    required bool isOnline,
    required String searchQuery,
    required NotesSortOrder sortOrder,
    required List<Note>? notesLocal,
    required List<Note>? notesRemote,
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
      sortOrder: NotesSortOrder.dateEdited,
      notesLocal: null,
      notesRemote: null,
      notesFiltered: [],
    );
  }

  bool get canSync => isOnline && notesLocal != null && notesRemote != null;

  List<Note> get notesPublished {
    final published = notesFiltered.where((note) => note.status == NoteStatus.published).toList();
    List<Note> publishedAndSorted = [];
    switch (sortOrder) {
      case NotesSortOrder.dateEdited:
        publishedAndSorted = published.sorted((a, b) => a.isMoreRecentThan(b) ? -1 : 1);
        break;
      case NotesSortOrder.dateCreated:
        publishedAndSorted = published.sorted((a, b) => a.dateCreated.isAfter(b.dateCreated) ? -1 : 1);
        break;
      case NotesSortOrder.title:
        publishedAndSorted = published.sortedBy((note) => note.title.toLowerCase());
        break;
    }
    return publishedAndSorted;
  }

  List<Note> get notesRemoved {
    return notesFiltered
        .where((note) => note.status == NoteStatus.archived)
        .toList()
        .sorted((a, b) => a.isMoreRecentThan(b) ? -1 : 1);
  }
}
