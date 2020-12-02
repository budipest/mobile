import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import 'CardTemplate.dart';
import '../../core/models/Note.dart';

class NoteCard extends StatelessWidget {
  const NoteCard(this.note,
      {this.isMine = false, this.removeHandler, this.reportHandler});
  final Note note;
  final bool isMine;
  final Function removeHandler;
  final Function reportHandler;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: CardTemplate(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (isMine)
              Padding(
                padding: EdgeInsets.only(bottom: 2.5),
                child: Text(
                  FlutterI18n.translate(context, "myNote"),
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Text(
              note.text,
              style: TextStyle(fontSize: 16.0),
            ),
            Padding(
              padding: EdgeInsets.only(top: 7.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    note.addDate.toString().substring(0, 16),
                    style: TextStyle(
                      fontSize: 14.0,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[700],
                    ),
                  ),
                  if (isMine)
                    GestureDetector(
                      onTap: () {
                        if (removeHandler != null) removeHandler();
                      },
                      child: Icon(
                        Icons.delete,
                        color: Colors.grey[700],
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: () {
                        // TODO: implement reporting a comment
                        if (reportHandler != null) reportHandler();
                      },
                      child: Icon(
                        Icons.flag,
                        color: Colors.grey[700],
                      ),
                    )
                ],
              ),
            )
          ],
        ),
        gradient: LinearGradient(
          stops: [0],
          colors: [Colors.grey[100]],
        ),
      ),
    );
  }
}
