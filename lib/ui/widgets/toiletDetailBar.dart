import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../../core/viewmodels/UserModel.dart';
import '../../core/models/toilet.dart';
import '../../core/models/note.dart';
import '../../core/services/api.dart';
import '../screens/addNote.dart';
import '../../locator.dart';
import './button.dart';
import './noteList.dart';
import './rateBar.dart';

class ToiletDetailBar extends StatefulWidget {
  const ToiletDetailBar(this.toilet);
  final Toilet toilet;

  @override
  State<StatefulWidget> createState() => ToiletDetailBarState();
}

class ToiletDetailBarState extends State<ToiletDetailBar> {
  ToiletDetailBarState();
  API _api = locator<API>();
  String userId = locator<UserModel>().userId;

  void addNote(String noteText, String uid) async {
    widget.toilet.notes.insert(0, Note(noteText, uid));
    _api.addToArray(
      widget.toilet.notes.map((Note note) => note.toJson()).toList(),
      widget.toilet.id,
      "notes",
    );
    Navigator.of(context).pop();
  }

  bool userHasNote(Toilet toilet) {
    bool vote = false;
    toilet.notes.forEach((Note note) {
      if (note.userId == userId) {
        vote = true;
      }
    });
    return vote;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(color: Colors.grey[100]),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: RateBar(widget.toilet, _api),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(24.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                FlutterI18n.translate(context, "notes"),
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              if (!userHasNote(widget.toilet))
                Hero(
                  tag: "addNoteButton",
                  child: Button(
                    FlutterI18n.translate(context, "newNote"),
                    () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => AddNote(
                            toilet: widget.toilet,
                            onNoteSubmitted: (String newNote) =>
                                addNote(newNote, userId),
                          ),
                        ),
                      );
                    },
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    isMini: true,
                  ),
                ),
            ],
          ),
        ),
        NoteList(widget.toilet),
      ],
    );
  }
}
