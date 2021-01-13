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
  AddNote();

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  String note;

  @override
  Widget build(BuildContext context) {
    final ToiletModel provider =
        Provider.of<ToiletModel>(context, listen: false);
    final Toilet toilet = provider.selectedToilet;

    return BlackLayoutContainer(
      context: context,
      inlineTitle: toilet.name,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
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
                      maxLines: null
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
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
                          FlutterI18n.translate(context, "send"),
                          () async {
                            await provider.addNote(note);
                            Navigator.of(context).pop();
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
