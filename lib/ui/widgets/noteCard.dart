import 'package:flutter/material.dart';

import './cardTemplate.dart';
import '../../core/models/note.dart';

class NoteCard extends StatelessWidget {
  const NoteCard(this.note);
  final Note note;

  @override
  Widget build(BuildContext context) {
    return CardTemplate(
      Row(children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Text(note.text),
            Text("itt kellene lennie egy notenak")
          ],
        ),
      ]),
    );
  }
}
