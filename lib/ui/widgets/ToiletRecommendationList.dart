import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';

import '../../core/providers/ToiletModel.dart';
import 'ToiletCard.dart';

class ToiletRecommendationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ToiletModel>(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0),
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
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: provider.toilets.length,
            shrinkWrap: true,
            itemBuilder: (context, index) => GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                provider.selectToilet(provider.toilets[index]);
              },
              child: ToiletCard(provider.toilets[index]),
            ),
          ),
        ],
      ),
    );
  }
}
