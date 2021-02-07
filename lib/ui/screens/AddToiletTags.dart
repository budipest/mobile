import 'package:flutter/material.dart';

import '../widgets/Selectable.dart';
import '../../core/models/Toilet.dart';

class AddToiletTags extends StatelessWidget {
  const AddToiletTags(
    this.onTagToggled,
    this.tags,
  );

  final Function onTagToggled;
  final List<Tag> tags;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 45, 30, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "services",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Selectable(
              "tag_wheelchair_accessible.svg",
              "accessible",
              onTagToggled,
              0,
              tags.contains(Tag.WHEELCHAIR_ACCESSIBLE),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Selectable(
              "tag_baby_room.svg",
              "babyRoom",
              onTagToggled,
              1,
              tags.contains(Tag.BABY_ROOM),
            ),
          ),
        ],
      ),
    );
  }
}
