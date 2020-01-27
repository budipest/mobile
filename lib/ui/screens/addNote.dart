import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../../core/models/note.dart';
import '../../core/models/toilet.dart';
import '../widgets/button.dart';
import '../widgets/blackLayoutContainer.dart';
import '../widgets/textInput.dart';

class AddNote extends StatefulWidget {
  AddNote(this.toilet, this.onNoteSubmitted);
  final Function(String) onNoteSubmitted;
  final Toilet toilet;

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  String note;

  @override
  Widget build(BuildContext context) {
    final List<Note> notes = widget.toilet.notes;

    return BlackLayoutContainer(
      context: context,
      inlineTitle: widget.toilet.title,
      child: Padding(
        padding: EdgeInsets.fromLTRB(30, 45, 30, 30),
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
                  FlutterI18n.translate(context, "newNotePlaceholder"), note,
                  (String newNote) {
                setState(() {
                  note = newNote;
                });
              }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Button(
                  FlutterI18n.translate(context, "send"),
                  () => widget.onNoteSubmitted(note),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  isMini: false,
                  verticalPadding: 6,
                  horizontalPadding: 30,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
