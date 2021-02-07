import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/ToiletModel.dart';
import '../../core/models/Toilet.dart';
import 'ToiletCard.dart';

class ToiletRecommendationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Toilet> toilets =
        context.select((ToiletModel m) => m.toilets.getRange(0, 20).toList());
    final Function selectToilet =
        context.select((ToiletModel m) => m.selectToilet);

    return Padding(
      padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "otherToilets",
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(height: 14),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: 20,
            shrinkWrap: true,
            itemBuilder: (context, index) => GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                selectToilet(toilets[index]);
              },
              child: ToiletCard(toilets[index]),
            ),
          ),
        ],
      ),
    );
  }
}
