import 'package:astralnote_app/models/note/note.dart';
import 'package:astralnote_app/router_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class NoteListItem extends StatelessWidget {
  const NoteListItem({
    required this.note,
    Key? key,
  }) : super(key: key);

  final Note note;

  @override
  Widget build(BuildContext context) {
    _viewNote() => Navigator.pushNamed(context, Routes.note.name, arguments: note);

    return PlatformWidget(
      material: (context, platform) => ListTile(
        onLongPress: () {},
        onTap: _viewNote,
        title: Text(note.title(), softWrap: false),
        subtitle: Text(note.subTitle(), softWrap: false),
      ),
      cupertino: (context, platform) => CupertinoButton(
        onPressed: _viewNote,
        padding: EdgeInsets.zero,
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PlatformText(note.title(), softWrap: false, style: const TextStyle(color: Colors.black)),
              const SizedBox(height: 8),
              PlatformText(note.subTitle(), softWrap: false, style: const TextStyle(color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }
}
