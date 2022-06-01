import 'package:freezed_annotation/freezed_annotation.dart';

part 'note.freezed.dart';

@freezed
class Note with _$Note {
  const factory Note({
    required String id,
    required String dateCreated,
    required String? dateUpdated,
    required String? color,
    required String content,
    required String header,
    required String subHeader,
  }) = _Note;

  const Note._();
}
