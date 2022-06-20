import 'dart:convert';
import 'dart:io';

import 'package:astralnote_app/models/note/note.dart';
import 'package:dartz/dartz.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

enum NotesLocalFailure { unexpected, ioError, updateFailed }

class NotesLocalRepository {
  static NotesLocalRepository? _instance;
  factory NotesLocalRepository() => _instance ??= NotesLocalRepository._();

  NotesLocalRepository._() {
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
      final notesRaw = await notesFile.readAsString();
      final Iterable notesJson = json.decode(notesRaw.isNotEmpty ? notesRaw : '[]');
      final notes = notesJson.map((noteJson) => Note.fromJson(noteJson)).toList();
      _notesController.add(right(notes));
    } catch (e) {
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

  Note updateNote(Note targetNote, {required String updatedContent}) {
    final updatedNote = targetNote.copyWith(content: updatedContent);
    final failureOrUpdatedNotes = _notesController.stream.value;
    return failureOrUpdatedNotes.fold(
      (_) => targetNote,
      (notes) {
        final noteIndex = notes.indexWhere((note) => note.id == targetNote.id);
        final updatedNotes = [...notes];
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
