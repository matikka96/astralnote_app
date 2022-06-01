import 'package:astralnote_app/models/generic_error.dart';
import 'package:astralnote_app/models/note/dto/note_dto.dart';
import 'package:astralnote_app/models/note/note.dart';
import 'package:astralnote_app/modules/dio_module.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class NotesRepository {
  static NotesRepository? _instance;
  factory NotesRepository() => _instance ??= NotesRepository._();
  NotesRepository._();

  static const _endpoint = '/items/note';

  Future<Either<GenericError, List<Note>>> loadNotes() async {
    try {
      final response = await DioModule().dio.get(_endpoint);
      final noteDTO = NoteDTO.fromJson(response.data);
      final notes = noteDTO.data.map((noteDataDTO) => noteDataDTO.toDomain()).toList();
      return right(notes);
    } catch (e) {
      if (e is DioError && e.response?.statusCode == 401) return left(GenericError.tokenExpired);
      if (e is DioError && e.response?.statusCode == 403) return left(GenericError.forbidden);
      return left(GenericError.unexpected);
    }
  }
}
