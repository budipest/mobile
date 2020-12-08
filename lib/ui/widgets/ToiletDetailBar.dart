import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';

import '../../core/models/Toilet.dart';
import '../../core/models/Note.dart';
import '../../core/providers/ToiletModel.dart';
import 'Button.dart';
import 'NoteList.dart';
import 'RatingBar.dart';

class ToiletDetailBar extends StatelessWidget {
  const ToiletDetailBar(this.toilet);
  final Toilet toilet;

  bool userHasNote(Toilet toilet, String userId) {
    bool noted = false;

    toilet.notes.forEach((Note note) {
      if (note.userId == userId) {
        noted = true;
      }
    });

    return noted;
  }

  @override
  Widget build(BuildContext context) {
    final ToiletModel provider = Provider.of<ToiletModel>(context);
    final String userId = provider.userId;

    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(color: Colors.grey[100]),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: RatingBar(toilet),
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
              if (!userHasNote(toilet, userId))
                Hero(
                  tag: "addNoteButton",
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
                  child: Button(
                    FlutterI18n.translate(context, "newNote"),
                    () {
                      Navigator.pushNamed(context, '/addNote');
                    },
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    isMini: true,
                  ),
                ),
            ],
          ),
        ),
        NoteList(toilet),
      ],
    );
  }
}
