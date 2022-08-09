import 'package:astralnote_app/domain/generic_error.dart';
import 'package:astralnote_app/domain/note/dto/note_dto.dart';
import 'package:astralnote_app/domain/note/dto/notes_dto.dart';
import 'package:astralnote_app/domain/note/note.dart';
import 'package:astralnote_app/modules/dio_module.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

class NotesRemoteRepository {
  NotesRemoteRepository({
    required DioModule dioModule,
  }) : _dio = dioModule.dio {
    loadNotesRemote();
  }

  final Dio _dio;
  final _notesRemoteController = BehaviorSubject<Either<GenericError, List<Note>>>();
  static const _endpoint = '/items/note';

  Stream<Either<GenericError, List<Note>>> get failureOrNotesRemote => _notesRemoteController.stream;

  Future<void> loadNotesRemote() async {
    try {
      final response = await _dio.get(_endpoint);
      final noteDTO = NotesDTO.fromJson(response.data);
      final notes = noteDTO.data.map((noteDataDTO) => noteDataDTO.toDomain(source: NoteSource.remote)).toList();
      _notesRemoteController.add(right(notes));
    } catch (e) {
      GenericError error = GenericError.unexpected;
      if (e is DioError && e.response?.statusCode == 401) error = GenericError.tokenExpired;
      if (e is DioError && e.response?.statusCode == 403) error = GenericError.forbidden;
      _notesRemoteController.add(left(error));
    }
  }

  Future<void> createMultipleNotes(List<Note> newNotes) async {
    for (var newNote in newNotes) {
      await _createSingleNote(newNote);
    }
  }

  Future<Either<GenericError, Note>> _createSingleNote(Note newNote) async {
    try {
      // TODO: Create a proper model for body
      final body = {'id': newNote.id, 'content': newNote.content, 'status': newNote.status.name};
      final response = await _dio.post(_endpoint, data: body);
      final createdNoteDTO = NoteDTO.fromJson(response.data);
      return right(createdNoteDTO.data.toDomain(source: NoteSource.remote));
    } catch (e) {
      GenericError error = GenericError.unexpected;
      if (e is DioError && e.response?.statusCode == 401) error = GenericError.tokenExpired;
      if (e is DioError && e.response?.statusCode == 403) error = GenericError.forbidden;
      return left(error);
    }
  }

  Future<void> updateMultipleNotes(List<Note> updatedNotes) async {
    for (var updatedNote in updatedNotes) {
      await _updateSingleNote(updatedNote);
    }
  }

  Future<Either<GenericError, Note>> _updateSingleNote(Note updatedNote) async {
    try {
      // TODO: Create a proper model for body
      final body = {'content': updatedNote.content, 'status': updatedNote.status.name};
      final response = await _dio.patch('$_endpoint/${updatedNote.id}', data: body);
      final updatedNoteDTO = NoteDTO.fromJson(response.data);
      return right(updatedNoteDTO.data.toDomain(source: NoteSource.remote));
    } catch (e) {
      GenericError error = GenericError.unexpected;
      if (e is DioError && e.response?.statusCode == 401) error = GenericError.tokenExpired;
      if (e is DioError && e.response?.statusCode == 403) error = GenericError.forbidden;
      return left(error);
    }
  }
}
