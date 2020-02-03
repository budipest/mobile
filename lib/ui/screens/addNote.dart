import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;
import 'package:flutter_i18n/flutter_i18n.dart';

import '../../core/models/toilet.dart';
import '../widgets/button.dart';
import '../widgets/blackLayoutContainer.dart';
import '../widgets/textInput.dart';
import '../widgets/noteList.dart';

class AddNote extends StatefulWidget {
  AddNote(this.toilet, this.onNoteSubmitted);
  final Function(String) onNoteSubmitted;
  final Toilet toilet;

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  @override
  void initState() {
    services.SystemChrome.setSystemUIOverlayStyle(services.SystemUiOverlayStyle.dark);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlackLayoutContainer(
      context: context,
      inlineTitle: widget.toilet.title,
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
                      FlutterI18n.translate(context, "newNotePlaceholder"),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Hero(
                        tag: "addNoteButton",
                        child: Button(
                          FlutterI18n.translate(context, "send"),
                          (String note) => widget.onNoteSubmitted(note),
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
            NoteList(widget.toilet),
          ],
        ),
      ),
    );
  }
}
