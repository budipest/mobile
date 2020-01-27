import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/models/toilet.dart';
import '../../core/services/api.dart';
import '../../core/models/note.dart';
import './button.dart';
import '../../locator.dart';
import '../screens/addNote.dart';
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

  void addNote(String noteText, String uid) async {
    widget.toilet.notes.insert(0, Note(noteText, uid));
    _api.addToArray(
      widget.toilet.notes.map((Note note) => note.toJson()).toList(),
      widget.toilet.id,
      "notes",
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    return Expanded(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.grey[100]),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: RateBar(widget.toilet, _api),
            ),
          ),
          StreamBuilder<FirebaseUser>(
            stream: _auth.onAuthStateChanged,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                FirebaseUser user = snapshot.data;
                if (user == null) {
                  _auth.signInAnonymously();
                }
                return Padding(
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
                      Hero(
                        tag: "addNoteButton",
                        child: Button(
                          FlutterI18n.translate(context, "newNote"),
                          () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => AddNote(
                                  widget.toilet,
                                  (String newNote) =>
                                      addNote(newNote, user.uid),
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
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          NoteList(widget.toilet.notes),
        ],
      ),
    );
  }
}
