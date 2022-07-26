import 'dart:async';

import 'package:astralnote_app/infrastructure/notes_local_repository.dart';
import 'package:astralnote_app/infrastructure/notes_remote_repository.dart';
import 'package:astralnote_app/domain/generic_error.dart';
import 'package:astralnote_app/domain/note/note.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'notes_state.dart';
part 'notes_cubit.freezed.dart';

class NotesCubit extends Cubit<NotesState> {
  final NotesLocalRepository _notesLocalRepository;
  final NotesRemoteRepository _notesRemoteRepository;
  StreamSubscription<Either<NotesLocalFailure, List<Note>>>? _notesLocalStreamSubscription;
  StreamSubscription<Either<GenericError, List<Note>>>? _notesRemoteStreamSubscription;

  NotesCubit({
    required NotesLocalRepository notesLocalRepository,
    required NotesRemoteRepository notesRemoteRepository,
  })  : _notesLocalRepository = notesLocalRepository,
        _notesRemoteRepository = notesRemoteRepository,
        super(NotesState.initial()) {
    _notesLocalStreamSubscription =
        _notesLocalRepository.failureOrNotesLocal.debounceTime(const Duration(seconds: 1)).listen(_onNotesLocalChanged);
    _notesRemoteStreamSubscription = _notesRemoteRepository.failureOrNotesRemote
        .debounceTime(const Duration(seconds: 1))
        .listen(_onNotesRemoteChanged);
  }

  Future<void> _onNotesLocalChanged(Either<NotesLocalFailure, List<Note>> failureOrNotes) async {
    failureOrNotes.fold(
      (error) => emit(state.copyWith(isLoading: false, isFailure: error)),
      (notesLocal) {
        emit(state.copyWith(isLoading: false, notesLocal: notesLocal));
        _syncNotes();
      },
    );
  }

  Future<void> _onNotesRemoteChanged(Either<GenericError, List<Note>> failureOrNotes) async {
    print('Notes loaded from remote');
    failureOrNotes.fold(
      (error) => emit(state.copyWith(isLoading: false)), // , isFailure: error
      (notesRemote) {
        emit(state.copyWith(isLoading: false, notesRemote: notesRemote));
        _syncNotes();
      },
    );
  }

  // 1. Move new remote notes --> local | DONE
  // 2. Replace local note with remote if needed based on updated_time | DONE
  // 3. Update remote notes with local based on updated_time
  Future<void> _syncNotes() async {
    if (state.canSync) {
      emit(state.copyWith(isSyncing: true));
      final remoteNoteIds = state.notesRemote!.map((note) => note.id);
      final localNoteIds = state.notesLocal!.map((note) => note.id);

      final newRemoteNotes = state.notesRemote!.where((noteRemote) => !localNoteIds.contains(noteRemote.id)).toList();
      final localAndNewNotes = [...state.notesLocal!, ...newRemoteNotes];

      final localAndNewNotesUpdated = localAndNewNotes.map((noteLocal) {
        final remoteVersionOfNote = state.notesRemote!.firstWhereOrNull((noteRemote) => noteRemote.id == noteLocal.id);
        if (remoteVersionOfNote != null && remoteVersionOfNote.isMoreRecentThan(noteLocal)) return remoteVersionOfNote;
        return noteLocal;
      }).toList();

      emit(state.copyWith(notesLocal: localAndNewNotesUpdated));

      final notesToPushRemote =
          localAndNewNotesUpdated.where((noteLocal) => !remoteNoteIds.contains(noteLocal.id)).toList();
      final notesToUpdateRemote = localAndNewNotesUpdated.where((noteLocal) {
        final remoteVersionOfNote = state.notesRemote!.firstWhereOrNull((noteRemote) => noteRemote.id == noteLocal.id);
        if (remoteVersionOfNote != null && noteLocal.isMoreRecentThan(remoteVersionOfNote)) return true;
        return false;
      }).toList();

      // print('--- TO PUSH ---');
      // notesToPushRemote.forEach((note) => print(note));
      // print('--- TO UPDATE ---');
      // notesToUpdateRemote.forEach((note) => print(note));

      await _notesRemoteRepository.createMultipleNotes(notesToPushRemote);
      await _notesRemoteRepository.updateMultipleNotes(notesToUpdateRemote);
      if (notesToPushRemote.isNotEmpty || notesToUpdateRemote.isNotEmpty) {
        await _notesRemoteRepository.loadNotesRemote();
      }
      emit(state.copyWith(isSyncing: false));
    }
  }

  void setSyncStatus({required bool isOnline}) => emit(state.copyWith(isOnline: isOnline));

  void onDeleteNote({required String? id}) => _notesLocalRepository.deleteNote(noteID: id);

  Future<void> onRefreshNotes() async {
    _syncNotes();
    _notesRemoteRepository.loadNotesRemote();
  }

  @override
  Future<void> close() async {
    await _notesLocalStreamSubscription?.cancel();
    await _notesRemoteStreamSubscription?.cancel();
    return super.close();
  }
}
