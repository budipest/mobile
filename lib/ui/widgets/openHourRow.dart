import 'package:flutter/material.dart';

import '../../core/common/openHourUtils.dart';
import '../../core/common/variables.dart';

class OpenHourRow extends StatefulWidget {
  OpenHourRow(this.onChange, this.openHours, this.index);
  final Function onChange;
  final List<int> openHours;
  final int index;

  @override
  _OpenHourRowState createState() =>
      _OpenHourRowState(onChange, openHours, index);
}

class _OpenHourRowState extends State<OpenHourRow> {
  _OpenHourRowState(this.onChange, this.openHours, this.index);
  final Function onChange;
  final List<int> openHours;
  final int index;

  @override
  Widget build(BuildContext context) {
    String day = days[(widget.index / 2).floor()];
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
              print(value);
              if (value == true) {
                if (widget.index != 0) {
                  widget.openHours[widget.index] =
                      widget.openHours[widget.index - 2];
                  widget.openHours[widget.index + 1] =
                      widget.openHours[widget.index - 1];
                } else {
                  widget.openHours[0] = 0;
                  widget.openHours[1] = 15;
                }
                setState(() {
                  isOn = true;
                });
              } else {
                widget.openHours[widget.index] = 0;
                widget.openHours[widget.index + 1] = 0;
                setState(() {
                  isOn = false;
                });
              }
              widget.onChange(widget.openHours);
            },
          ),
          Container(
            width: 50,
            child: Text(
              day,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                  items:
                      possibleOpenHours.map<DropdownMenuItem<int>>((int value) {
                    String valueAsString = minuteToHourFormat(value);
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                    widget.onChange(widget.openHours);
                  },
                  items:
                      possibleOpenHours.map<DropdownMenuItem<int>>((int value) {
                    String valueAsString = minuteToHourFormat(value);
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
    );
  }
}
