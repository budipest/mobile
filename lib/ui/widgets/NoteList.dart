import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';

import '../../core/models/Note.dart';
import '../../core/providers/ToiletModel.dart';
import '../../core/models/Toilet.dart';
import 'NoteCard.dart';

class NoteList extends StatelessWidget {
  NoteList(this.toilet);
  final Toilet toilet;

  void removeNote(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext innerContext) {
        return AlertDialog(
          title: new Text(
            FlutterI18n.translate(context, "areYouSure"),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
          content: new Text(
            FlutterI18n.translate(context, "irreversibleNote"),
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: Text(FlutterI18n.translate(context, "cancel")),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: Text(
                FlutterI18n.translate(context, "remove"),
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Provider.of<ToiletModel>(context, listen: false).removeNote();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String userId = Provider.of<ToiletModel>(context).userId;

    toilet.notes.forEach((Note note) {
      if (note.userId == userId) {
        toilet.notes.remove(note);
        toilet.notes.insert(0, note);
      }
    });

    return Hero(
      tag: "notelist",
      child: Padding(
        padding: EdgeInsets.only(top: 0, left: 20, right: 20),
        child: Column(
          children: <Widget>[
            ...toilet.notes.map(
              (Note note) => NoteCard(
                note,
                isMine: note.userId == userId,
                removeHandler: () => removeNote(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
