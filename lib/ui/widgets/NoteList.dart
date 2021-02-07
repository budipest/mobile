import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/Note.dart';
import '../../core/providers/ToiletModel.dart';
import '../../core/models/Toilet.dart';
import 'CardTemplate.dart';
import 'NoteCard.dart';

class NoteList extends StatelessWidget {
  NoteList(this.toilet);

  final Toilet toilet;

  void removeNote(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext innerContext) {
        return AlertDialog(
          title: Text(
            "areYouSure",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
          content: Text(
            "irreversibleNote",
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                "remove",
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
    final String userId =
        Provider.of<ToiletModel>(context, listen: false).userId;

    toilet.notes.forEach((Note note) {
      if (note.userId == userId) {
        toilet.notes.remove(note);
        toilet.notes.insert(0, note);
      }
    });

    return Hero(
      tag: "noteList",
      flightShuttleBuilder: (
        BuildContext flightContext,
        Animation<double> animation,
        HeroFlightDirection flightDirection,
        BuildContext fromHeroContext,
        BuildContext toHeroContext,
      ) =>
          Material(
        color: Colors.transparent,
        child: toHeroContext.widget,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 0, left: 20, right: 20),
        child: toilet.notes.length > 0
            ? Column(
                children: <Widget>[
                  ...toilet.notes.map(
                    (Note note) => NoteCard(
                      note,
                      isMine: note.userId == userId,
                      removeHandler: () => removeNote(context),
                    ),
                  ),
                ],
              )
            : CardTemplate(
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "empty.notes-title",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(height: 8),
                    Text(
                      "empty.notes-description",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                gradient: LinearGradient(
                  stops: [0],
                  colors: [Colors.grey[100]],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              ),
      ),
    );
  }
}
