import 'package:astralnote_app/domain/note/dto/note_data_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_dto.freezed.dart';
part 'note_dto.g.dart';

@freezed
class NoteDTO with _$NoteDTO {
  const factory NoteDTO({
    @JsonKey(name: 'data') required NoteDataDTO data,
  }) = _NoteDTO;

  const NoteDTO._();

  factory NoteDTO.fromJson(Map<String, dynamic> json) => _$NoteDTOFromJson(json);
}
