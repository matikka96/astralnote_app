import 'dart:async';

import 'package:astralnote_app/domain/local_config/note_sort_order.dart';
import 'package:astralnote_app/domain/note/note.dart';
import 'package:astralnote_app/infrastructure/directus_connector_service.dart';
import 'package:astralnote_app/infrastructure/network_monitor_repository.dart';
import 'package:astralnote_app/infrastructure/notes_local_repository.dart';
import 'package:astralnote_app/infrastructure/notes_remote_repository.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:rxdart/rxdart.dart';

part 'notes_cubit.freezed.dart';
part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit({
    required NotesLocalRepository notesLocalRepository,
    required NotesRemoteRepository notesRemoteRepository,
    required NetworkMonitorRepository networkMonitorRepository,
  })  : _notesLocalRepository = notesLocalRepository,
        _notesRemoteRepository = notesRemoteRepository,
        _networkMonitorRepository = networkMonitorRepository,
        super(NotesState.initial()) {
    _notesLocalStreamSubscription = _notesLocalRepository.failureOrNotesLocal
        .debounceTime(const Duration(milliseconds: 100))
        .listen(_onNotesLocalChanged);
    _notesRemoteStreamSubscription = _notesRemoteRepository.failureOrNotesRemote
        .debounceTime(const Duration(milliseconds: 100))
        .listen(_onNotesRemoteChanged);
    _searchQuerySubject
        .debounceTime(const Duration(milliseconds: 100))
        .listen((searchInput) => emit(state.copyWith(searchQuery: searchInput)));
    _connectionStatusStream = _networkMonitorRepository.status
        .listen((connectivityStatus) => emit(state.copyWith(connectivity: connectivityStatus)));
  }
  final NotesLocalRepository _notesLocalRepository;
  final NotesRemoteRepository _notesRemoteRepository;
  final NetworkMonitorRepository _networkMonitorRepository;

  StreamSubscription<Either<NotesLocalFailure, List<Note>>>? _notesLocalStreamSubscription;
  StreamSubscription<Either<DirectusError, List<Note>>>? _notesRemoteStreamSubscription;
  StreamSubscription<NetworkStatus>? _connectionStatusStream;
  final _searchQuerySubject = BehaviorSubject<String>();

  Future<void> _onNotesLocalChanged(Either<NotesLocalFailure, List<Note>> failureOrNotes) async {
    failureOrNotes.fold(
      (error) => emit(state.copyWith(status: NotesFailure.localFailure)),
      (notesLocal) {
        emit(state.copyWith(notesLocal: notesLocal, notesFiltered: notesLocal, isInitialLoading: false));
        _iterateNotes();
      },
    );
  }

  Future<void> _onNotesRemoteChanged(Either<DirectusError, List<Note>> failureOrNotes) async {
    failureOrNotes.fold(
      (error) => emit(state.copyWith(status: NotesFailure.remoteFailure)),
      (notesRemote) {
        emit(state.copyWith(notesRemote: notesRemote));
        _iterateNotes();
      },
    );
  }

  Future<void> _iterateNotes() async {
    if (state.canSync) {
      final allNotes = [...state.notesRemote!, ...state.notesLocal!];

      final List<Note> notesParsed = [],
          notesToUpdateRemote = [],
          notesToPushRemote = [],
          notesToRemoveRemote = [],
          notesToUpdateLocal = [],
          notesToPushLocal = [],
          notesToRemoveLocal = [];

      for (var note in allNotes) {
        final noteNotFoundFromParsedList = !notesParsed.map((e) => e.id).contains(note.id);
        if (noteNotFoundFromParsedList) {
          final localVersion = allNotes.firstWhereOrNull((n) => n.id == note.id && n.source == NoteSource.local);
          final remoteVersion = allNotes.firstWhereOrNull((n) => n.id == note.id && n.source == NoteSource.remote);

          if (localVersion != null && remoteVersion != null) {
            if (localVersion.status == NoteStatus.deleted) {
              notesToRemoveLocal.add(localVersion);
              notesToRemoveRemote.add(remoteVersion);
              notesParsed.add(localVersion);
            } else if (localVersion.isMoreRecentThan(remoteVersion)) {
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
            if (localVersion.status == NoteStatus.deleted) {
              notesToRemoveLocal.add(localVersion);
              notesParsed.add(localVersion);
            } else if (localVersion.isQualifiedForDeletion) {
              notesToRemoveLocal.add(localVersion);
            } else {
              notesToPushRemote.add(localVersion);
              notesParsed.add(localVersion);
            }
          }
        }
      }

      // Sync notes with cloud if needed & possible
      if (notesToPushRemote.isNotEmpty || notesToUpdateRemote.isNotEmpty || notesToRemoveRemote.isNotEmpty) {
        await _notesRemoteRepository.createMultipleNotes(notesToPushRemote);
        await _notesRemoteRepository.updateMultipleNotes(notesToUpdateRemote);
        await _notesRemoteRepository.deleteNotesWithIds(notesToRemoveRemote);
        await _notesRemoteRepository.loadNotesRemote();
      } else {
        emit(state.copyWith(isSyncing: false));
      }

      // Update local notes up to date
      for (var note in [...notesToPushLocal, ...notesToUpdateLocal]) {
        _notesLocalRepository.addOrUpdateNote(note);
      }
      for (var note in notesToRemoveLocal) {
        _notesLocalRepository.deleteNoteWithId(note.id);
      }
    }
  }

  void onUpdateSearchQuery(String searchQuery) {
    emit(state.copyWith(isSyncing: true));
    _searchQuerySubject.add(searchQuery);
  }

  void onChangeNoteStatus({required Note note, required NoteStatus newNoteStatus}) {
    final updatedNote = note.copyWith(status: newNoteStatus, dateUpdated: DateTime.now().toUtc());
    _notesLocalRepository.addOrUpdateNote(updatedNote);
  }

  Future<void> onRefreshNotesRemote() async {
    await _notesRemoteRepository.loadNotesRemote();
  }

  void onUpdateSortOrder({required NotesSortOrder updatedSortOrder}) {
    emit(state.copyWith(sortOrder: updatedSortOrder));
  }

  void onDispose() {
    _notesLocalRepository.dispose();
    _notesRemoteRepository.dispose();
    emit(state.copyWith(
      searchQuery: '',
      notesLocal: null,
      notesRemote: null,
      notesFiltered: [],
    ));
  }

  @override
  Future<void> close() async {
    await _searchQuerySubject.close();
    await _notesLocalStreamSubscription?.cancel();
    await _notesRemoteStreamSubscription?.cancel();
    await _connectionStatusStream?.cancel();
    onDispose();
    return super.close();
  }
}
