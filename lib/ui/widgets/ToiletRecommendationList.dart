import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../../core/models/Toilet.dart';
import 'ToiletCard.dart';

class ToiletRecommendationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            FlutterI18n.translate(context, "otherToilets"),
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(height: 14),
          ...toilets.map(
            (Toilet toilet) => GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                selectToilet(toilet);
              },
              child: ToiletCard(toilet),
            ),
          ),
        ],
      ),
    );
  }
}
