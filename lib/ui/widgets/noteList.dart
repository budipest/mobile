import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../core/models/note.dart';

import '../../core/viewmodels/UserModel.dart';
import './noteCard.dart';
import '../../locator.dart';

class NoteList extends StatelessWidget {
  const NoteList(this.notes);
  final List<Note> notes;

  @override
  Widget build(BuildContext context) {
    final UserModel userModel = locator<UserModel>();
    return Expanded(
      child: Hero(
        tag: "notelist",
        child: ListView.builder(
          padding: EdgeInsets.only(top: 0, left: 20, right: 20),
          itemCount: notes.length,
          itemBuilder: (BuildContext ctxt, int index) => GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              // TODO: implement reporting of a toilet
            },
            child: NoteCard(
              notes[index],
              isMine: notes[index].userId == userModel.userId,
            ),
          ),
        ),
      ),
    );
  }
}
