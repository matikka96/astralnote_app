import 'dart:async';

import 'package:astralnote_app/infrastructure/notes_local_repository.dart';
import 'package:astralnote_app/domain/note/note.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'view_note_state.dart';
part 'view_note_cubit.freezed.dart';

class ViewNoteCubit extends Cubit<ViewNoteState> {
  ViewNoteCubit({
    required NotesLocalRepository notesLocalRepository,
  })  : _notesLocalRepository = notesLocalRepository,
        super(const ViewNoteState(editingNote: null)) {
    _noteEditingSubsription = _noteEditingController.stream
        .debounceTime(const Duration(seconds: 5))
        .listen((updatedNote) => _updateLocalNote(updatedNote));
  }

  final NotesLocalRepository _notesLocalRepository;
  StreamSubscription<Note>? _noteEditingSubsription;

  final _noteEditingController = BehaviorSubject<Note>();

  onInit({required Note note}) => emit(state.copyWith(editingNote: note));

  onNoteUpdate(Note note, {required String updatedContent}) {
    if (state.editingNote != null && state.editingNote!.content != updatedContent) {
      final updatedNote = note.copyWith(content: updatedContent, dateUpdated: DateTime.now().toUtc());
      emit(state.copyWith(editingNote: updatedNote));
      _noteEditingController.add(updatedNote);
    }
  }

  _updateLocalNote(Note updatedNote) {
    _notesLocalRepository.addOrUpdateNote(updatedNote);
  }

  @override
  Future<void> close() async {
    await _noteEditingSubsription?.cancel();

    final savedVersionOfNote = _notesLocalRepository.findNoteById(state.editingNote?.id ?? '');
    if (state.editingNote != null && state.editingNote!.content != savedVersionOfNote?.content) {
      _updateLocalNote(state.editingNote!);
    }

    return super.close();
  }
}
