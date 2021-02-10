import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/common/openHourUtils.dart';
import '../../core/common/variables.dart';

class OpenHourRow extends StatefulWidget {
  OpenHourRow(
    this.onChange,
    this.openHours,
    this.lastEditedDayStartIndex,
    this.lastEditedOpening,
    this.lastEditedClosing,
    this.index,
    this.dayLabel,
  );

  final Function onChange;
  final List<int> openHours;
  final int lastEditedDayStartIndex;
  final int lastEditedOpening;
  final int lastEditedClosing;
  final int index;
  final String dayLabel;

  @override
  _OpenHourRowState createState() => _OpenHourRowState();
}

class _OpenHourRowState extends State<OpenHourRow> {
  @override
  Widget build(BuildContext context) {
    bool isOn = widget.openHours[widget.index] != 0 ||
        widget.openHours[widget.index + 1] != 0;

    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Row(
        children: <Widget>[
          Checkbox(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            value: isOn,
            checkColor: Colors.black,
            activeColor: Colors.grey[300],
            onChanged: (bool value) {
              if (value == true) {
                if (widget.lastEditedDayStartIndex == -1 ||
                    (widget.lastEditedOpening == 0 &&
                        widget.lastEditedClosing == 0)) {
                  widget.openHours[widget.index] = 0;
                  widget.openHours[widget.index + 1] = 15;
                } else {
                  widget.openHours[widget.index] = widget.lastEditedOpening;
                  widget.openHours[widget.index + 1] = widget.lastEditedClosing;
                }
              } else {
                widget.openHours[widget.index] = 0;
                widget.openHours[widget.index + 1] = 0;
              }

              setState(() {
                isOn = value;
              });

              widget.onChange(widget.openHours, widget.index);
            },
          ),
          Container(
            width: 50,
            child: Text(
              widget.dayLabel,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Expanded(
            child: isOn
                ? Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: DropdownButton<int>(
                                value: widget.openHours[widget.index],
                                elevation: 16,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Muli',
                                ),
                                icon: Icon(null),
                                isExpanded: true,
                                underline: Container(height: 0),
                                onChanged: (int newValue) {
                                  widget.openHours[widget.index] = newValue;
                                  widget.onChange(widget.openHours);
                                },
                                items: possibleOpenHours
                                    .map<DropdownMenuItem<int>>((int value) {
                                  String valueAsString =
                                      minuteToHourFormat(value);
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Text(valueAsString),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 17.5),
                          child: Text(
                            "-",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: DropdownButton<int>(
                                value: widget.openHours[widget.index + 1],
                                elevation: 16,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Muli',
                                ),
                                icon: Icon(null),
                                underline: Container(height: 0),
                                onChanged: (int newValue) {
                                  widget.openHours[widget.index + 1] = newValue;
                                  widget.onChange(
                                      widget.openHours, widget.index);
                                },
                                items: possibleOpenHours
                                    .map<DropdownMenuItem<int>>((int value) {
                                  String valueAsString =
                                      minuteToHourFormat(value);
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Text(valueAsString),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Text(
                      AppLocalizations.of(context).closed,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
