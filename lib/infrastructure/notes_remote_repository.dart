import 'package:astralnote_app/domain/note/dto/note_dto.dart';
import 'package:astralnote_app/domain/note/note.dart';
import 'package:astralnote_app/infrastructure/directus_connector_service.dart';
import 'package:dartz/dartz.dart';
import 'package:rxdart/rxdart.dart';

class NotesRemoteRepository {
  NotesRemoteRepository({
    required DirectusConnectorService directusItemConnector,
  }) : _directusItemConnector = directusItemConnector;

  final DirectusConnectorService _directusItemConnector;
  static const _collection = 'note';

  final _notesRemoteController = BehaviorSubject<Either<DirectusError, List<Note>>>();

  Stream<Either<DirectusError, List<Note>>> get failureOrNotesRemote => _notesRemoteController.stream;

  Future<void> loadNotesRemote() async {
    final failureOrRemoteNotes = await _directusItemConnector.getMany(collection: _collection);
    failureOrRemoteNotes.fold(
      (error) => _notesRemoteController.add(left(error)),
      (remoteNotesJson) {
        final notesDTO = remoteNotesJson.map((noteJson) => NoteDTO.fromJson(noteJson));
        final notes = notesDTO.map((noteDTO) => noteDTO.toDomain(source: NoteSource.remote)).toList();
        _notesRemoteController.add(right(notes));
      },
    );
  }

  Future<void> createMultipleNotes(List<Note> newNotes) async {
    for (var newNote in newNotes) {
      await _createSingleNote(newNote);
    }
  }

  Future<void> _createSingleNote(Note newNote) async {
    final newItem = {'id': newNote.id, 'content': newNote.content, 'status': newNote.status.name};
    final failureOrNewNote = await _directusItemConnector.post(collection: _collection, body: newItem);
    failureOrNewNote.fold(
      (error) {}, // Do something with error
      (newNoteJson) {}, // Do something with newNoteJson
    );
  }

  Future<void> updateMultipleNotes(List<Note> updatedNotes) async {
    for (var updatedNote in updatedNotes) {
      await _updateSingleNote(updatedNote);
    }
  }

  Future<void> _updateSingleNote(Note updatedNote) async {
    final updatedItem = {'content': updatedNote.content, 'status': updatedNote.status.name};
    final failureOrNewNote = await _directusItemConnector.patch(
      collection: _collection,
      id: updatedNote.id,
      body: updatedItem,
    );
    failureOrNewNote.fold(
      (error) {}, // Do something with error
      (newNoteJson) {}, // Do something with newNoteJson
    );
  }

  Future<void> deleteNotesWithIds(List<Note> notes) async {
    final List<String> succesfullyDeleted = [], unsuccesfullyDeleted = []; // Do something with unsuccesfullyDeleted ?
    for (var note in notes) {
      final failureOrNoteDeleted = await _directusItemConnector.delete(collection: _collection, id: note.id);
      failureOrNoteDeleted.fold((_) => unsuccesfullyDeleted.add(note.id), (_) => succesfullyDeleted.add(note.id));
    }
  }

  void dispose() {
    final List<Note> emptyNotes = [];
    _notesRemoteController.add(right(emptyNotes));
  }
}
