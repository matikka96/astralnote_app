import 'dart:convert';
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

  void _loadNotes() async {
    try {
      final notesFile = await _localNotesFile;
      String? notesRaw = await notesFile.readAsString();
      Iterable notesJson = [];
      try {
        notesJson = json.decode(notesRaw);
      } catch (e) {
        print('Could not parse notes from local file');
      }
      final notes = notesJson.map((noteJson) => Note.fromJson(noteJson)).toList();
      _notesController.add(right(notes));
    } catch (e) {
      print('Error loading local notes');
      _notesController.add(left(NotesLocalFailure.unexpected));
    }
  }

  void _saveNotes() async {
    try {
      final notesFile = await _localNotesFile;
      final failureOrNotes = _notesController.stream.value;
      final notes = failureOrNotes.fold((_) => null, (notes) => notes.map((note) => note.toJson()).toList());
      await notesFile.writeAsString(json.encode(notes));
    } catch (e) {
      _notesController.add(left(NotesLocalFailure.ioError));
    }
  }

  addNote({required Note note}) {
    final failureOrExistingNotes = _notesController.stream.value;
    failureOrExistingNotes.fold(
      (_) => print('Could not add note'),
      (notes) {
        final updatedNotes = [...notes, note];
        _notesController.add(right(updatedNotes));
      },
    );
  }

  Note addOrUpdateNote(Note note) {
    // final updatedNote = targetNote.copyWith(content: updatedContent);
    final failureOrUpdatedNotes = _notesController.stream.value;
    return failureOrUpdatedNotes.fold(
      (_) => note,
      (localNotes) {
        final noteIndex = localNotes.indexWhere((localNote) => localNote.id == note.id);
        final updatedNotes = [...localNotes];
        if (noteIndex == -1) {
          updatedNotes.add(note);
          _notesController.add(right(updatedNotes));
          return note;
        } else {
          updatedNotes[noteIndex] = note;
          _notesController.add(right(updatedNotes));
          return note;
        }
      },
    );
  }

  deleteNote({required String? noteID}) {
    final failureOrCleanedNotes = _notesController.stream.value;
    failureOrCleanedNotes.fold(
      (l) => print('Could not update list'),
      (notes) {
        final updatedNotes = [...notes]..removeWhere((note) => note.id == noteID);
        _notesController.add(right(updatedNotes));
      },
    );
  }
}
