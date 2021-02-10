import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/Button.dart';
import '../widgets/OpenHourRow.dart';

class AddToiletOpenHours extends StatefulWidget {
  AddToiletOpenHours(
    this.onOpenHoursChanged,
    this.onNonStopChanged,
    this.openHours,
    this.isNonStop,
  );

  final Function onOpenHoursChanged;
  final Function onNonStopChanged;
  final List<int> openHours;
  final bool isNonStop;

  @override
  _AddToiletOpenHoursState createState() => _AddToiletOpenHoursState();
}

class _AddToiletOpenHoursState extends State<AddToiletOpenHours> {
  int lastEditedDayStartIndex = -1;
  int lastEditedOpening = 0;
  int lastEditedClosing = 0;

  void onOpenHoursChanged(List<int> openHours, int changeIndex) {
    lastEditedDayStartIndex = changeIndex;
    lastEditedOpening = openHours[changeIndex];
    lastEditedClosing = openHours[changeIndex + 1];

    widget.onOpenHoursChanged(openHours);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
      children: <Widget>[
        Text(
          AppLocalizations.of(context).openHours,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Button(
            AppLocalizations.of(context).alwaysOpen,
            () {
              widget.onNonStopChanged(!widget.isNonStop);
            },
            backgroundColor: widget.isNonStop ? Colors.black : Colors.grey[300],
            foregroundColor: widget.isNonStop ? Colors.white : Colors.black,
          ),
        ),
        if (!widget.isNonStop && widget.openHours.length == 14)
          Column(
            children: <Widget>[
              OpenHourRow(
                onOpenHoursChanged,
                widget.openHours,
                lastEditedDayStartIndex,
                lastEditedOpening,
                lastEditedClosing,
                0,
                AppLocalizations.of(context).mondayShort,
              ),
              OpenHourRow(
                onOpenHoursChanged,
                widget.openHours,
                lastEditedDayStartIndex,
                lastEditedOpening,
                lastEditedClosing,
                2,
                AppLocalizations.of(context).tuesdayShort,
              ),
              OpenHourRow(
                onOpenHoursChanged,
                widget.openHours,
                lastEditedDayStartIndex,
                lastEditedOpening,
                lastEditedClosing,
                4,
                AppLocalizations.of(context).wednesdayShort,
              ),
              OpenHourRow(
                onOpenHoursChanged,
                widget.openHours,
                lastEditedDayStartIndex,
                lastEditedOpening,
                lastEditedClosing,
                6,
                AppLocalizations.of(context).thursdayShort,
              ),
              OpenHourRow(
                onOpenHoursChanged,
                widget.openHours,
                lastEditedDayStartIndex,
                lastEditedOpening,
                lastEditedClosing,
                8,
                AppLocalizations.of(context).fridayShort,
              ),
              OpenHourRow(
                onOpenHoursChanged,
                widget.openHours,
                lastEditedDayStartIndex,
                lastEditedOpening,
                lastEditedClosing,
                10,
                AppLocalizations.of(context).saturdayShort,
              ),
              OpenHourRow(
                onOpenHoursChanged,
                widget.openHours,
                lastEditedDayStartIndex,
                lastEditedOpening,
                lastEditedClosing,
                12,
                AppLocalizations.of(context).sundayShort,
              ),
            ],
          ),
        Container(
          height: 80,
        ),
      ],
    );
  }
}
