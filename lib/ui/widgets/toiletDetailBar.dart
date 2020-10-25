import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../../core/models/Toilet.dart';
import '../../core/models/Note.dart';
import '../../core/services/API.dart';
import '../screens/AddNote.dart';
import '../../locator.dart';
import 'Button.dart';
import 'NoteList.dart';
import 'RatingBar.dart';

class ToiletDetailBar extends StatefulWidget {
  const ToiletDetailBar(this.toilet);
  final Toilet toilet;

  @override
  State<StatefulWidget> createState() => ToiletDetailBarState();
}

class ToiletDetailBarState extends State<ToiletDetailBar> {
  ToiletDetailBarState();
  // String userId = locator<UserModel>().userId;

  void addNote(String noteText, String uid) async {
    widget.toilet.notes.insert(0, Note(noteText, uid));
    // TODO: implement adding a note
    // _api.addToArray(
    //   widget.toilet.notes.map((Note note) => note.toJson()).toList(),
    //   widget.toilet.id,
    //   "notes",
    // );
    Navigator.of(context).pop();
  }

  bool userHasNote(Toilet toilet) {
    bool vote = false;
    // TODO: implement checking notes
    // toilet.notes.forEach((Note note) {
    //   if (note.userId == userId) {
    //     vote = true;
    //   }
    // });
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
            child: RatingBar(widget.toilet),
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
                            onNoteSubmitted: (String note) =>
                                print("this is not implemented yet"),
                            // TOOD: implement submitting notes
                            // onNoteSubmitted: (String newNote) =>
                            //     addNote(newNote, userId),
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
