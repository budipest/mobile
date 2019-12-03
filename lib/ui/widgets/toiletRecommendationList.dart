import 'package:flutter/material.dart';

import '../../core/models/toilet.dart';
import './toiletCard.dart';

class ToiletRecommendationList extends StatelessWidget {
  const ToiletRecommendationList(this.toilets, this.selectToilet);
  final List<Toilet> toilets;
  final Function(Toilet) selectToilet;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "További mosdók",
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: toilets.length,
                itemBuilder: (BuildContext ctxt, int index) => GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    selectToilet(toilets[index]);
                  },
                  child: ToiletCard(toilets[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
