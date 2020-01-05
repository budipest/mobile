import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../widgets/selectable.dart';
import '../../core/models/toilet.dart';

class AddToiletTags extends StatelessWidget {
  const AddToiletTags(this.onTagToggled, this.tags);
  final Function onTagToggled;
  final List<Tag> tags;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30, 45, 30, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            FlutterI18n.translate(context, "services"),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Selectable(
              "tag_wheelchair_accessible.svg",
              FlutterI18n.translate(context, "accessible"),
              null,
              onTagToggled,
              0,
              tags.contains(Tag.WHEELCHAIR_ACCESSIBLE),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Selectable(
              "tag_baby_room.svg",
              FlutterI18n.translate(context, "babyRoom"),
              null,
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
