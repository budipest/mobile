import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';

import '../../core/models/Toilet.dart';
import '../../core/providers/ToiletModel.dart';

import '../widgets/Button.dart';
import '../widgets/BlackLayoutContainer.dart';
import '../widgets/TextInput.dart';
import '../widgets/NoteList.dart';

class AddNote extends StatefulWidget {
  AddNote({this.onNoteSubmitted});
  final Function(String) onNoteSubmitted;

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  String note;

  @override
  Widget build(BuildContext context) {
    final Toilet toilet = Provider.of<ToiletModel>(context).selectedToilet;

    return BlackLayoutContainer(
      context: context,
      inlineTitle: toilet.name,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(20, 45, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    FlutterI18n.translate(context, "newNote"),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                    child: TextInput(
                      note,
                      FlutterI18n.translate(context, "newNotePlaceholder"),
                      onTextChanged: (String text) {
                        setState(() {
                          note = text;
                        });
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Hero(
                        tag: "addNoteButton",
                        child: Button(
                          FlutterI18n.translate(context, "send"),
                          () {
                            widget.onNoteSubmitted(note);
                          },
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          isMini: false,
                          verticalPadding: 6,
                          horizontalPadding: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            NoteList(toilet),
          ],
        ),
      ),
    );
  }
}
