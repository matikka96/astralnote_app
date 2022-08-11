import 'package:astralnote_app/domain/note/note.dart';
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_dto.freezed.dart';
part 'note_dto.g.dart';

@freezed
class NoteDTO with _$NoteDTO {
  const factory NoteDTO({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'status') required String status,
    @JsonKey(name: 'sort') required String? sort,
    @JsonKey(name: 'user_created') required String userCreated,
    @JsonKey(name: 'date_created') required String dateCreated,
    @JsonKey(name: 'user_updated') required String? userUpdated,
    @JsonKey(name: 'date_updated') required String? dateUpdated,
    @JsonKey(name: 'content') required String content,
    @JsonKey(name: 'color') required String? color,
  }) = _NoteDTO;

  const NoteDTO._();

  factory NoteDTO.fromJson(Map<String, dynamic> json) => _$NoteDTOFromJson(json);

  Note toDomain({required NoteSource source}) {
    final parsedStatus = NoteStatus.values.firstWhereOrNull((noteStatus) => noteStatus.name == status);

    return Note(
      id: id,
      status: parsedStatus ?? NoteStatus.published,
      dateCreated: DateTime.parse(dateCreated),
      dateUpdated: dateUpdated != null ? DateTime.parse(dateUpdated!) : null,
      content: content,
      color: color,
      source: source,
    );
  }
}
