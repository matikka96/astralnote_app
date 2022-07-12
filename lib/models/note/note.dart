import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'note.freezed.dart';
part 'note.g.dart';

@freezed
class Note with _$Note {
  const factory Note({
    required String id,
    required DateTime dateCreated,
    required String content,
    DateTime? dateUpdated,
    String? color,
  }) = _Note;

  const Note._();

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  factory Note.create() {
    final randomBytes = utf8.encode(Random().nextDouble().toString());
    final randomID = sha1.convert(randomBytes).toString();

    return Note(
      id: randomID,
      dateCreated: DateTime.now().toUtc(),
      content: '',
    );
  }

  String get title {
    final rows = content.split('\n');
    for (var i = 0; i < rows.length; i++) {
      final row = rows[i];
      if (row.isNotEmpty) return row;
    }
    return 'New note';
  }

  String get subTitle {
    final rows = content.split('\n');
    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.isNotEmpty) return row;
    }
    return '';
  }
}
