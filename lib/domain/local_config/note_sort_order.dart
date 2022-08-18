enum NotesSortOrder { dateEdited, dateCreated, title }

class SortOrderOption {
  SortOrderOption({
    required this.name,
    required this.order,
  });
  final String name;
  final NotesSortOrder order;
}
