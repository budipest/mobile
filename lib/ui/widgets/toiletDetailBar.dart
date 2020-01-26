import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/models/toilet.dart';
import '../../core/viewmodels/ToiletModel.dart';
import '../../core/services/api.dart';
import './button.dart';
import '../../locator.dart';
import '../screens/addNote.dart';

class ToiletDetailBar extends StatefulWidget {
  const ToiletDetailBar(this.toilet);
  final Toilet toilet;

  @override
  State<StatefulWidget> createState() => ToiletDetailBarState(toilet);
}

class ToiletDetailBarState extends State<ToiletDetailBar> {
  ToiletDetailBarState(this.toilet);
  Toilet toilet;
  int myVote;
  API _api = locator<API>();
  String note;

  void addNote(String note) {
    print(note);
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
    snapshot.setInt(toilet.id, vote);
    _api.updateDocument(
        {"upvotes": toilet.upvotes, "downvotes": toilet.downvotes}, toilet.id);
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
                    myVote = snapshot.data.getInt(toilet.id) ?? 0;
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
                            toilet.upvotes.toString(),
                            () => vote(
                              snapshot.data,
                              toiletProvider,
                              toilet,
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
                          toilet.downvotes.toString(),
                          () => vote(
                            snapshot.data,
                            toiletProvider,
                            toilet,
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
                              builder: (context) => AddNote(toilet, addNote, note),
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
        ],
      ),
    );
  }
}
