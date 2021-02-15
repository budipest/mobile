import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final Toilet selectedToilet =
        context.select((ToiletModel m) => m.selectedToilet);
    final Function addNote = context.select((ToiletModel m) => m.addNote);

    return BlackLayoutContainer(
      context: context,
      inlineTitle: selectedToilet.name,
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
                    AppLocalizations.of(context).newNote,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                    child: TextInput(
                        note, AppLocalizations.of(context).newNotePlaceholder,
                        onTextChanged: (String text) {
                      setState(() {
                        note = text;
                      });
                    }, maxLines: null),
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
                          AppLocalizations.of(context).send,
                          () async {
                            await addNote(note);
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
            NoteList(selectedToilet),
          ],
        ),
      ),
    );
  }
}
