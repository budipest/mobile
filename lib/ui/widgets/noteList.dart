import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../core/models/note.dart';

import '../../core/viewmodels/UserModel.dart';
import '../../core/models/toilet.dart';
import '../../core/services/api.dart';
import '../../locator.dart';
import './noteCard.dart';

class NoteList extends StatelessWidget {
  NoteList(this.toilet);
  final Toilet toilet;
  final API _api = locator<API>();

  void removeNote() {
    List<dynamic> remove = new List<dynamic>();
    remove.add(toilet.notes[0].toJson());
    _api.removeFromArray(
      remove,
      toilet.id,
      "notes",
    );
    toilet.notes.removeAt(0);
  }

  @override
  Widget build(BuildContext context) {
    final String userId = locator<UserModel>().userId;

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
                removeHandler: removeNote,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
