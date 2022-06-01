import 'package:astralnote_app/models/note/note.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_data_dto.freezed.dart';
part 'note_data_dto.g.dart';

@freezed
class NoteDataDTO with _$NoteDataDTO {
  const factory NoteDataDTO({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'status') required String status,
    @JsonKey(name: 'sort') required String? sort,
    @JsonKey(name: 'user_created') required String userCreated,
    @JsonKey(name: 'date_created') required String dateCreated,
    @JsonKey(name: 'user_updated') required String? userUpdated,
    @JsonKey(name: 'date_updated') required String? dateUpdated,
    @JsonKey(name: 'content') required String content,
    @JsonKey(name: 'color') required String? color,
  }) = _NoteDataDTO;

  const NoteDataDTO._();

  factory NoteDataDTO.fromJson(Map<String, dynamic> json) => _$NoteDataDTOFromJson(json);

  Note toDomain() {
    return Note(
      id: id,
      dateCreated: dateCreated,
      dateUpdated: dateUpdated,
      content: content,
      color: color,
      header: _parseHeader(content),
      subHeader: _parseSubHeader(content),
    );
  }

  // TODO: Finish parse method
  String _parseHeader(String content) {
    return '';
  }

  // TODO: Finish parse method
  String _parseSubHeader(String content) {
    return '';
  }
}
