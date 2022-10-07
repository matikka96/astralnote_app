part of 'notes_cubit.dart';

enum NotesFailure { none, localFailure, remoteFailure, unexpected }

@freezed
class NotesState with _$NotesState {
  const factory NotesState({
    required bool isInitialLoading,
    required bool isSyncing,
    required String searchQuery,
    required NotesSortOrder sortOrder,
    required NetworkStatus connectivity,
    required List<Note>? notesLocal,
    required List<Note>? notesRemote,
    required List<Note> notesFiltered,
    required NotesFailure status,
  }) = _NotesState;

  const NotesState._();

  factory NotesState.initial() {
    return const NotesState(
      isInitialLoading: true,
      isSyncing: false,
      searchQuery: '',
      sortOrder: NotesSortOrder.dateEdited,
      connectivity: NetworkStatus.offline,
      notesLocal: null,
      notesRemote: null,
      notesFiltered: [],
      status: NotesFailure.none,
    );
  }

  bool get canSync => !isSyncing && notesLocal != null && notesRemote != null && connectivity == NetworkStatus.online;

  List<Note> get notesPublished => notesFiltered.where((note) => note.status == NoteStatus.published).toList();

  List<Note> get publishedAndSorted {
    final allNotes = notesPublished;
    List<Note> publishedAndSorted = [];

    if (searchQuery.isEmpty) {
      switch (sortOrder) {
        case NotesSortOrder.dateEdited:
          publishedAndSorted = allNotes.sorted((a, b) => a.isMoreRecentThan(b) ? -1 : 1);
          break;
        case NotesSortOrder.dateCreated:
          publishedAndSorted = allNotes.sorted((a, b) => a.dateCreated.isAfter(b.dateCreated) ? -1 : 1);
          break;
        case NotesSortOrder.title:
          publishedAndSorted = allNotes.sortedBy((note) => note.title.toLowerCase());
          break;
      }
    } else {
      final searchResult = extractAllSorted<Note>(
        query: searchQuery,
        choices: allNotes.where((note) => note.status == NoteStatus.published).toList(),
        cutoff: 50,
        getter: (note) => note.content,
      ).map((result) => result.choice).toList();
      publishedAndSorted.addAll(searchResult);
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
