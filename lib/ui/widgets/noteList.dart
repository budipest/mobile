import 'package:flutter/material.dart';
import '../../core/models/note.dart';
import './noteCard.dart';

class NoteList extends StatelessWidget {
  const NoteList(this.notes);
  final List<Note> notes;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Hero(
        tag: "notelist",
        child: ListView.builder(
          padding: EdgeInsets.only(top: 0, left: 20, right: 20),
          itemCount: notes.length,
          itemBuilder: (BuildContext ctxt, int index) => GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              // selectToilet(toilets[index]);
            },
            child: NoteCard(notes[index]),
          ),
        ),
      ),
    );
  }
}
