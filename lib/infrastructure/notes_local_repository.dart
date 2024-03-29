import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:astralnote_app/domain/note/note.dart';
import 'package:dartz/dartz.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

enum NotesLocalFailure { unexpected, ioError, updateFailed }

class NotesLocalRepository {
  NotesLocalRepository() {
    _loadNotes();
    failureOrNotesLocal.debounceTime(const Duration(seconds: 1)).listen((_) => _saveNotes());
  }

  final _notesController = BehaviorSubject<Either<NotesLocalFailure, List<Note>>>();

  Stream<Either<NotesLocalFailure, List<Note>>> get failureOrNotesLocal => _notesController.stream;

  static const _filename = 'notes-local.json';

  Future<File> get _localNotesFile async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/$_filename';
    final file = File(path);
    if (await file.exists()) {
      return file;
    } else {
      return await File(path).create(recursive: true);
    }
  }

  Future<void> _loadNotes() async {
    try {
      final notesFile = await _localNotesFile;
      String? notesRaw = await notesFile.readAsString();
      List<Note> notes = [];
      try {
        final notesJson = json.decode(notesRaw);
        for (var noteJson in notesJson) {
          final note = Note.fromJson(noteJson).copyWith(source: NoteSource.local);
          notes.add(note);
        }
        _notesController.add(right(notes));
      } catch (e) {
        log(e.toString());
      }
      _notesController.add(right(notes));
    } catch (e) {
      log(e.toString());
      _notesController.add(left(NotesLocalFailure.unexpected));
    }
  }

  Future<void> _saveNotes() async {
    try {
      final notesFile = await _localNotesFile;
      final failureOrNotes = _notesController.stream.value;
      failureOrNotes.fold(
        (_) {},
        (notes) async {
          final notesJson = notes.map((note) => note.toJson()).toList();
          await notesFile.writeAsString(json.encode(notesJson));
        },
      );
    } catch (e) {
      _notesController.add(left(NotesLocalFailure.ioError));
    }
  }

  Note addOrUpdateNote(Note note) {
    final updatedNote = note.copyWith(source: NoteSource.local);
    final failureOrUpdatedNotes = _notesController.stream.value;
    return failureOrUpdatedNotes.fold(
      (_) => note,
      (localNotes) {
        final noteIndex = localNotes.indexWhere((localNote) => localNote.id == updatedNote.id);
        final updatedNotes = [...localNotes];
        if (noteIndex == -1) {
          updatedNotes.add(updatedNote);
          _notesController.add(right(updatedNotes));
          return updatedNote;
        } else {
          updatedNotes[noteIndex] = updatedNote;
          _notesController.add(right(updatedNotes));
          return updatedNote;
        }
      },
    );
  }

  Note? findNoteById(String id) {
    final noteWeAreLookingFor = _notesController.stream.value;
    return noteWeAreLookingFor.fold(
      (_) => null,
      (localNotes) {
        final noteIndex = localNotes.indexWhere((localNote) => localNote.id == id);
        if (noteIndex != -1) return localNotes[noteIndex];
        return null;
      },
    );
  }

  void deleteNoteWithId(String noteId) {
    final failureOrNoteDeleted = _notesController.stream.value;
    failureOrNoteDeleted.fold(
      (_) => log('Could not delete note'),
      (notes) {
        final updatedNotes = [...notes]..removeWhere((note) => note.id == noteId);
        _notesController.add(right(updatedNotes));
      },
    );
  }

  void dispose() {
    final List<Note> emptyNotes = [];
    _notesController.add(right(emptyNotes));
  }
}
