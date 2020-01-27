import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/models/toilet.dart';
import '../../core/viewmodels/ToiletModel.dart';
import '../../core/services/api.dart';
import '../../core/models/note.dart';
import './button.dart';
import '../../locator.dart';
import '../screens/addNote.dart';
import './noteCard.dart';

class ToiletDetailBar extends StatefulWidget {
  const ToiletDetailBar(this.toilet);
  final Toilet toilet;

  @override
  State<StatefulWidget> createState() => ToiletDetailBarState();
}

class ToiletDetailBarState extends State<ToiletDetailBar> {
  ToiletDetailBarState();
  int myVote;
  API _api = locator<API>();

  void addNote(String noteText, String uid) async {
    widget.toilet.notes.add(Note(noteText, uid));
    _api.addToArray(
      widget.toilet.notes.map((Note note) => note.toJson()).toList(),
      widget.toilet.id,
      "notes",
    );
    Navigator.of(context).pop();
  }

  void vote(SharedPreferences snapshot, ToiletModel toiletProvider,
      Toilet toilet, bool isUpvote) {
    switch (myVote) {
      case 1:
        {
          if (isUpvote) {
            toilet.upvotes -= 1;
          } else {
            toilet.upvotes -= 1;
            toilet.downvotes += 1;
          }
          setState(() {
            myVote = isUpvote ? 0 : -1;
          });
          break;
        }
      // if I don't have anything, add a vote
      case 0:
        {
          isUpvote ? toilet.upvotes += 1 : toilet.downvotes += 1;
          setState(() {
            myVote = isUpvote ? 1 : -1;
          });
          break;
        }
      case -1:
        {
          if (isUpvote) {
            toilet.upvotes += 1;
            toilet.downvotes -= 1;
          } else {
            toilet.downvotes -= 1;
          }
          setState(() {
            myVote = isUpvote ? 1 : 0;
          });
          break;
        }
    }
    castVote(snapshot, toiletProvider, myVote);
  }

  void castVote(
      SharedPreferences snapshot, ToiletModel toiletProvider, int vote) async {
    snapshot.setInt(widget.toilet.id, vote);
    Map<String, dynamic> votes = new Map<String, dynamic>();
    votes["upvotes"] = widget.toilet.upvotes;
    votes["downvotes"] = widget.toilet.downvotes;
    _api.updateDocument(votes, widget.toilet.id);
  }

  @override
  Widget build(BuildContext context) {
    final toiletProvider = Provider.of<ToiletModel>(context);
    final FirebaseAuth _auth = FirebaseAuth.instance;

    return Expanded(
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.grey[100]),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: FutureBuilder<SharedPreferences>(
                future: SharedPreferences.getInstance(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    myVote = snapshot.data.getInt(widget.toilet.id) ?? 0;
                    return Row(
                      children: <Widget>[
                        Text(
                          FlutterI18n.translate(context, "rate"),
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Button(
                            widget.toilet.upvotes.toString(),
                            () => vote(
                              snapshot.data,
                              toiletProvider,
                              widget.toilet,
                              true,
                            ),
                            icon: Icons.thumb_up,
                            backgroundColor:
                                myVote == 1 ? Colors.black : Colors.grey[600],
                            foregroundColor: Colors.white,
                            isMini: true,
                          ),
                        ),
                        Button(
                          widget.toilet.downvotes.toString(),
                          () => vote(
                            snapshot.data,
                            toiletProvider,
                            widget.toilet,
                            false,
                          ),
                          icon: Icons.thumb_down,
                          backgroundColor:
                              myVote == -1 ? Colors.black : Colors.grey[600],
                          foregroundColor: Colors.white,
                          isMini: true,
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
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
                      Button(
                        FlutterI18n.translate(context, "newNote"),
                        () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              fullscreenDialog: true,
                              builder: (context) => AddNote(
                                widget.toilet,
                                (String newNote) => addNote(newNote, user.uid),
                              ),
                            ),
                          );
                        },
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        isMini: true,
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
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10),
              itemCount: widget.toilet.notes.length,
              itemBuilder: (BuildContext ctxt, int index) => GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  // selectToilet(toilets[index]);
                },
                child: NoteCard(widget.toilet.notes[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
