import 'dart:async';

import 'package:astralnote_app/infrastructure/notes_local_repository.dart';
import 'package:astralnote_app/models/note/note.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'notes_state.dart';
part 'notes_cubit.freezed.dart';

class NotesCubit extends Cubit<NotesState> {
  final NotesLocalRepository _notesLocalRepository;
  StreamSubscription<Either<NotesLocalFailure, List<Note>>>? _notesStreamSubscription;

  NotesCubit({
    required NotesLocalRepository notesLocalRepository,
  })  : _notesLocalRepository = notesLocalRepository,
        super(NotesState.initial()) {
    _notesStreamSubscription =
        _notesLocalRepository.failureOrNotesLocal.debounceTime(const Duration(seconds: 1)).listen(_onNotesChanged);
  }

  Future<void> _onNotesChanged(Either<NotesLocalFailure, List<Note>> failureOrNotes) async {
    failureOrNotes.fold(
      (error) => emit(state.copyWith(isLoading: false, isFailure: error)),
      (notes) => emit(state.copyWith(isLoading: false, notes: notes)),
    );
  }

  setSyncStatus({required bool syncActive}) => emit(state.copyWith(syncActive: syncActive));

  onDeleteNote({required String? id}) => _notesLocalRepository.deleteNote(noteID: id);

  @override
  Future<void> close() async {
    await _notesStreamSubscription?.cancel();

    return super.close();
  }
}
