import 'package:astralnote_app/domain/note/dto/note_data_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notes_dto.freezed.dart';
part 'notes_dto.g.dart';

@freezed
class NotesDTO with _$NotesDTO {
  const factory NotesDTO({
    @JsonKey(name: 'data') required List<NoteDataDTO> data,
  }) = _NotesDTO;

  const NotesDTO._();

  factory NotesDTO.fromJson(Map<String, dynamic> json) => _$NotesDTOFromJson(json);
}
