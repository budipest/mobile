import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import "AskPermission.dart";
import 'ToiletDetailBar.dart';
import 'ToiletRecommendationList.dart';
import "RecommendedToilet.dart";

import '../../core/models/Toilet.dart';
import '../../core/providers/ToiletModel.dart';

class BottomBar extends StatelessWidget {
  const BottomBar(
    this.scrollProgress,
    this.sc,
  );

  final double scrollProgress;
  final ScrollController sc;

  @override
  Widget build(BuildContext context) {
    final Toilet selectedToilet =
        context.select((ToiletModel m) => m.selectedToilet);
    final bool hasLocationPermission =
        context.select((ToiletModel m) => m.hasLocationPermission);

    bool hasSelected = selectedToilet != null;

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(
        controller: sc,
        physics: scrollProgress == 0
            ? NeverScrollableScrollPhysics()
            : ClampingScrollPhysics(),
        children: !hasSelected
            ? hasLocationPermission
                ? <Widget>[
                    RecommendedToilet(scrollProgress),
                    ToiletRecommendationList()
                  ]
                : [AskPermission(scrollProgress, sc)]
            : <Widget>[
                RecommendedToilet(scrollProgress),
                ToiletDetailBar(selectedToilet),
              ],
      ),
    );
  }
}
