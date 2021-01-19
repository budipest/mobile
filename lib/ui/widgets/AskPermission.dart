import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:flutter_i18n/flutter_i18n.dart";

import "BottomBarBlackContainer.dart";
import "CardTemplate.dart";
import '../../core/providers/ToiletModel.dart';

class AskPermission extends StatelessWidget {
  const AskPermission(
    this.scrollProgress,
    this.sc,
  );

  final double scrollProgress;
  final ScrollController sc;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ToiletModel>(context);

    return Column(
      children: [
        BottomBarBlackContainer(
          scrollProgress,
          provider.askLocationPermission,
          Text(
            FlutterI18n.translate(context, "noLocation.title"),
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              fontFamily: "Muli",
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0),
          child: CardTemplate(
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  FlutterI18n.translate(context, "noLocation.card-title"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(height: 8),
                Text(
                  FlutterI18n.translate(context, "noLocation.card-description"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            gradient: LinearGradient(
              stops: [0],
              colors: [Colors.grey[100]],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 25,
            ),
          ),
        ),
      ],
    );
  }
}
