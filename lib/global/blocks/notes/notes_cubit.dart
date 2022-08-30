import 'dart:async';

import 'package:astralnote_app/domain/local_config/note_sort_order.dart';
import 'package:astralnote_app/infrastructure/notes_local_repository.dart';
import 'package:astralnote_app/infrastructure/notes_remote_repository.dart';
import 'package:astralnote_app/domain/generic_error.dart';
import 'package:astralnote_app/domain/note/note.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:rxdart/rxdart.dart';

part 'notes_state.dart';
part 'notes_cubit.freezed.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit({
    required NotesLocalRepository notesLocalRepository,
    required NotesRemoteRepository notesRemoteRepository,
  })  : _notesLocalRepository = notesLocalRepository,
        _notesRemoteRepository = notesRemoteRepository,
        super(NotesState.initial()) {
    _notesLocalStreamSubscription = _notesLocalRepository.failureOrNotesLocal
        .debounceTime(const Duration(milliseconds: 100))
        .listen(_onNotesLocalChanged);
    _notesRemoteStreamSubscription = _notesRemoteRepository.failureOrNotesRemote
        // .debounceTime(const Duration(seconds: 1))
        .listen(_onNotesRemoteChanged);
    _searchQuerySubject.debounceTime(const Duration(milliseconds: 100)).listen((searchInput) {
      emit(state.copyWith(searchQuery: searchInput));
      _onFilterNotes();
    });
  }
  final NotesLocalRepository _notesLocalRepository;
  final NotesRemoteRepository _notesRemoteRepository;
  StreamSubscription<Either<NotesLocalFailure, List<Note>>>? _notesLocalStreamSubscription;
  StreamSubscription<Either<GenericError, List<Note>>>? _notesRemoteStreamSubscription;
  final _searchQuerySubject = BehaviorSubject<String>();

  Future<void> _onNotesLocalChanged(Either<NotesLocalFailure, List<Note>> failureOrNotes) async {
    failureOrNotes.fold(
      (error) => emit(state.copyWith(isLoading: false, isFailure: error)),
      (notesLocal) {
        if (state.notesRemote != null) {
          emit(state.copyWith(isLoading: false, notesLocal: notesLocal));
          _syncNotes();
        } else {
          emit(state.copyWith(
            isLoading: false,
            notesLocal: notesLocal,
            notesParsed: notesLocal,
            notesFiltered: notesLocal,
          ));
        }
      },
    );
  }

  Future<void> _onNotesRemoteChanged(Either<GenericError, List<Note>> failureOrNotes) async {
    failureOrNotes.fold(
      (error) => emit(state.copyWith(isLoading: false)),
      (notesRemote) {
        emit(state.copyWith(isLoading: false, notesRemote: notesRemote));
        _syncNotes();
      },
    );
  }

  Future<void> _syncNotes() async {
    if (state.canSync) {
      emit(state.copyWith(isSyncing: true));

      final notesRemote = state.notesRemote!, notesLocal = state.notesLocal!;
      final allNotes = [...notesRemote, ...notesLocal];

      final List<Note> notesParsed = [],
          notesToUpdateRemote = [],
          notesToPushRemote = [],
          notesToUpdateLocal = [],
          notesToPushLocal = [],
          notesToRemoveLocal = [];

      for (var note in allNotes) {
        final noteNotFoundFromParsedList = !notesParsed.map((e) => e.id).contains(note.id);
        if (noteNotFoundFromParsedList) {
          final localVersion = allNotes.firstWhereOrNull((n) => n.id == note.id && n.source == NoteSource.local);
          final remoteVersion = allNotes.firstWhereOrNull((n) => n.id == note.id && n.source == NoteSource.remote);

          if (localVersion != null && remoteVersion != null) {
            if (localVersion.isMoreRecentThan(remoteVersion)) {
              notesToUpdateRemote.add(localVersion);
              notesParsed.add(localVersion);
            } else if (remoteVersion.isMoreRecentThan(localVersion)) {
              notesToUpdateLocal.add(remoteVersion);
              notesParsed.add(remoteVersion);
            } else {
              notesParsed.add(remoteVersion);
            }
          } else if (localVersion == null) {
            notesToPushLocal.add(remoteVersion!);
            notesParsed.add(remoteVersion);
          } else if (remoteVersion == null) {
            if (localVersion.isQualifiedForDeletion) {
              notesToRemoveLocal.add(localVersion);
            } else {
              notesToPushRemote.add(localVersion);
              notesParsed.add(localVersion);
            }
          }
        }
      }

      emit(state.copyWith(
        notesParsed: notesParsed,
        notesFiltered: notesParsed,
      ));

      for (var note in [...notesToPushLocal, ...notesToUpdateLocal]) {
        _notesLocalRepository.addOrUpdateNote(note);
      }
      await _notesRemoteRepository.createMultipleNotes(notesToPushRemote);
      await _notesRemoteRepository.updateMultipleNotes(notesToUpdateRemote);

      if (notesToPushRemote.isEmpty || notesToUpdateRemote.isEmpty) {
        emit(state.copyWith(isSyncing: false));
      } else {
        await _notesRemoteRepository.loadNotesRemote();
      }
    }
  }

  void onUpdateSearchQuery(String searchQuery) {
    _searchQuerySubject.add(searchQuery);
  }

  _onFilterNotes() {
    final List<Note> filteredNotes = [];

    final searchQuery = state.searchQuery;
    if (searchQuery.isNotEmpty) {
      final searchResult = extractAllSorted<Note>(
        query: searchQuery,
        choices: state.notesParsed.where((note) => note.status == NoteStatus.published).toList(),
        cutoff: 50,
        getter: (note) => note.content,
      ).map((result) => result.choice).toList();

      filteredNotes.addAll(searchResult);
    } else {
      filteredNotes.addAll(state.notesParsed);
    }

    emit(state.copyWith(notesFiltered: filteredNotes));
  }

  void onOnlineStatusChanged({required bool isOnline}) {
    emit(state.copyWith(isOnline: isOnline));
  }

  void onNoteRestore(Note note) {
    final updatedNote = note.copyWith(status: NoteStatus.published, dateUpdated: DateTime.now().toUtc());
    _notesLocalRepository.addOrUpdateNote(updatedNote);
  }

  void onNoteDelete(Note note) {
    final updatedNote = note.copyWith(status: NoteStatus.archived, dateUpdated: DateTime.now().toUtc());
    _notesLocalRepository.addOrUpdateNote(updatedNote);
  }

  Future<void> onNoteDeletePermanently(Note note) async {
    await _notesRemoteRepository.deleteNoteWithId(note.id);
    _notesLocalRepository.deleteNoteWithId(note.id);
  }

  Future<void> onRefreshNotes() async {
    await _notesRemoteRepository.loadNotesRemote();
  }

  void onUpdateSortOrder({required NotesSortOrder updatedSortOrder}) {
    emit(state.copyWith(sortOrder: updatedSortOrder));
  }

  void onDispose() {
    emit(NotesState.initial());
    _notesLocalRepository.dispose();
    _notesRemoteRepository.dispose();
  }

  @override
  Future<void> close() async {
    await _searchQuerySubject.close();
    await _notesLocalStreamSubscription?.cancel();
    await _notesRemoteStreamSubscription?.cancel();
    onDispose();
    return super.close();
  }
}
