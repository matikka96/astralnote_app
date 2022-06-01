import 'package:astralnote_app/infrastructure/notes_repository.dart';
import 'package:astralnote_app/models/generic_error.dart';
import 'package:astralnote_app/models/note/note.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notes_state.dart';
part 'notes_cubit.freezed.dart';

class NotesCubit extends Cubit<NotesState> {
  NotesCubit() : super(NotesState.initial());

  init() {
    loadNotes();
  }

  loadNotes() async {
    final failureOrNotes = await NotesRepository().loadNotes();
    failureOrNotes.fold(
      (error) => emit(const NotesState(isLoading: false, notes: [])),
      (notes) => emit(NotesState(isLoading: false, notes: notes)),
    );
  }
}
