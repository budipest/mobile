import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../widgets/Button.dart';
import '../widgets/OpenHourRow.dart';

class AddToiletOpenHours extends StatelessWidget {
  AddToiletOpenHours(
    this.onOpenHoursChanged,
    this.openHours,
  );

  final Function onOpenHoursChanged;
  final List<int> openHours;

  @override
  Widget build(BuildContext context) {
    bool isNonStop =
        openHours[0] == 0 && openHours[1] == 1440 && openHours.length == 2;

    return ListView(
      padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
      children: <Widget>[
        Text(
          FlutterI18n.translate(context, "openHours"),
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: Button(
            FlutterI18n.translate(context, "alwaysOpen"),
            () {
              if (isNonStop) {
                onOpenHoursChanged(List<int>.filled(14, 0));
              } else {
                onOpenHoursChanged([0, 1440]);
              }
            },
            backgroundColor: isNonStop ? Colors.black : Colors.grey[300],
            foregroundColor: isNonStop ? Colors.white : Colors.black,
          ),
        ),
        if (!isNonStop && openHours.length == 14)
          Column(
            children: <Widget>[
              OpenHourRow(onOpenHoursChanged, openHours, 0),
              OpenHourRow(onOpenHoursChanged, openHours, 2),
              OpenHourRow(onOpenHoursChanged, openHours, 4),
              OpenHourRow(onOpenHoursChanged, openHours, 6),
              OpenHourRow(onOpenHoursChanged, openHours, 8),
              OpenHourRow(onOpenHoursChanged, openHours, 10),
              OpenHourRow(onOpenHoursChanged, openHours, 12),
            ],
          ),
        Container(
          height: 80,
        ),
      ],
    );
  }
}
