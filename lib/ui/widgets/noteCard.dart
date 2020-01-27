import 'package:flutter/material.dart';

import './cardTemplate.dart';
import '../../core/models/note.dart';

class NoteCard extends StatelessWidget {
  const NoteCard(this.note, {this.isMine = false});
  final Note note;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: CardTemplate(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              note.text,
              style: TextStyle(fontSize: 16.0),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                children: <Widget>[
                  Text(
                    note.addDate.toString().substring(0, 16),
                    style: TextStyle(
                      fontSize: 14.0,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        gradient: LinearGradient(
          stops: [0],
          colors: [Colors.grey[100]],
        ),
        verticalPadding: 25,
      ),
    );
  }
}
