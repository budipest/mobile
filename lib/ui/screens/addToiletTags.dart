import 'package:flutter/material.dart';

import '../widgets/selectable.dart';
import '../../core/models/toilet.dart';

class AddToiletTags extends StatelessWidget {
  const AddToiletTags(this.onTagToggled, this.tags);
  final Function(int) onTagToggled;
  final List<Tag> tags;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30, 200, 30, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Szolgáltatások",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Selectable(
              "cat_general.svg",
              "utcai WC",
              null,
              onTagToggled,
              0,
              tags.contains(Tag.WHEELCHAIR_ACCESSIBLE),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Selectable(
              "cat_restaurant.svg",
              "étterem / kávézó",
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
