import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import 'dart:async';
import 'dart:core';

import '../models/Toilet.dart';
import './bitmapFromSvg.dart';

Widget descriptionIcon(
    EdgeInsetsGeometry padding, String mode, bool smaller, String text,
    {String iconPath, IconData icon}) {
  return Padding(
    padding: padding,
    child: Container(
      constraints: BoxConstraints(
        minHeight: 35,
        minWidth: 35,
        // maxWidth: text != null ? 200 : 35,
        maxHeight: 35,
      ),
      decoration: BoxDecoration(
        color: mode == "light" ? Colors.black : Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 7.5,
          horizontal: text != null ? 12.5 : 7.5,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            icon != null
                ? Icon(icon, size: smaller ? 17.5 : 20)
                : SvgPicture.asset(
                    iconPath,
                    width: smaller ? 17.5 : 20,
                    height: smaller ? 17.5 : 20,
                  ),
            if (text != null)
              Padding(
                padding: EdgeInsets.only(left: 12.5),
                child: Text(
                  text,
                  style: TextStyle(
                    color: mode == "light" ? Colors.white : Colors.black,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

Widget entryMethodIcon(Toilet toilet, EdgeInsetsGeometry padding, String mode) {
  String path;

  switch (toilet.entryMethod) {
    case EntryMethod.FREE:
      path = "assets/icons/bottom/$mode/tag_free.svg";
      break;
    case EntryMethod.CONSUMERS:
      path = "assets/icons/bottom/$mode/tag_guests.svg";
      break;
    case EntryMethod.PRICE:
      path = "assets/icons/bottom/$mode/tag_paid.svg";
      break;
    case EntryMethod.CODE:
      path = "assets/icons/bottom/$mode/tag_key.svg";
      break;
    default:
      return null;
  }

  return descriptionIcon(
    padding,
    mode,
    true,
    null,
    iconPath: path,
  );
}

Widget entryMethodIconDetailed(Toilet toilet, EdgeInsetsGeometry padding) {
  switch (toilet.entryMethod) {
    case EntryMethod.FREE:
      return descriptionIcon(
        padding,
        "dark",
        true,
        null,
        iconPath: "assets/icons/bottom/dark/tag_free.svg",
      );
    case EntryMethod.CONSUMERS:
      return descriptionIcon(
        padding,
        "dark",
        true,
        null,
        iconPath: "assets/icons/bottom/dark/tag_guests.svg",
      );
    case EntryMethod.PRICE:
      var priceIcons = List<Widget>();
      if (toilet.price != null) {
        toilet.price.forEach((dynamic currency, dynamic value) {
          priceIcons.add(
            descriptionIcon(
              padding,
              "dark",
              true,
              "$value $currency",
              iconPath: "assets/icons/bottom/dark/tag_paid.svg",
            ),
          );
        });
      } else {
        priceIcons.add(
          descriptionIcon(
            padding,
            "dark",
            true,
            null,
            iconPath: "assets/icons/bottom/dark/tag_paid.svg",
          ),
        );
      }

      return Wrap(
        children: priceIcons,
      );
    case EntryMethod.CODE:
      return descriptionIcon(
        padding,
        "dark",
        true,
        toilet.code != null ? toilet.code : "",
        iconPath: "assets/icons/bottom/dark/tag_key.svg",
      );
    default:
      return null;
  }
}

String openState(List<int> openHours) {
  if (openHours[0] >= openHours[1]) {
    return "_unknown";
  }

  DateTime dateTime = DateTime.now();
  int curr = (dateTime.hour * 60) + dateTime.minute;
  int start = 0;
  int end = 1;

  if (openHours.length > 2) {
    start = (dateTime.weekday - 1) * 2;
    end = start + 1;
  }

  if (openHours[start] <= curr && curr <= openHours[end]) {
    return "_open";
  } else {
    return "_closed";
  }
}

bool isOpen(List<int> openHours) {
  if (openState(openHours) == "_open") {
    return true;
  }
  return false;
}

Color coloredOpenState(List<int> openHours) {
  if (openHours[0] >= openHours[1]) {
    return Colors.grey;
  }

  DateTime dateTime = DateTime.now();
  int curr = (dateTime.hour * 60) + dateTime.minute;
  int start = 0;
  int end = 1;

  if (openHours.length > 2) {
    start = (dateTime.weekday - 1) * 2;
    end = start + 1;
  }

  if (openHours[start] <= curr && curr <= openHours[end]) {
    return Colors.green;
  } else {
    return Colors.red;
  }
}

List<String> readableOpenState(List<int> openHours, BuildContext context) {
  List<String> result = [];
  if (openHours[0] >= openHours[1]) {
    result.add(FlutterI18n.translate(context, "unknown"));
    result.add("");
    return result;
  }

  DateTime dateTime = DateTime.now();
  int curr = (dateTime.hour * 60) + dateTime.minute;
  int start = 0;
  int end = 1;

  if (openHours.length > 2) {
    start = (dateTime.weekday - 1) * 2;
    end = start + 1;
  }

  if (openHours[start] <= curr && curr <= openHours[end]) {
    result.add(FlutterI18n.translate(context, "open") + " ");
    if (openHours[0] == 0 && openHours[1] == 1440) {
      result.add("24/7");
    } else {
      result.add(
        FlutterI18n.translate(
          context,
          "todayUntil",
          Map.fromIterables(["time"], [minuteToHourFormat(openHours[end])]),
        ),
      );
    }
  } else {
    result.add(FlutterI18n.translate(context, "closed") + " ");
    if (openHours[start] > curr) {
      result.add(
        FlutterI18n.translate(
          context,
          "todayUntil",
          Map.fromIterables(["time"], [minuteToHourFormat(openHours[start])]),
        ),
      );
    } else {
      if (end > 1) {
        result.add(FlutterI18n.translate(
          context,
          "tomorrowUntil",
          Map.fromIterables(["time"],
              [minuteToHourFormat(openHours[end + 1 >= 14 ? 0 : end + 1])]),
        ));
      } else {
        result.add(FlutterI18n.translate(
          context,
          "tomorrowUntil",
          Map.fromIterables(["time"], [minuteToHourFormat(openHours[start])]),
        ));
      }
    }
  }

  return result;
}

String stringFromCategory(Category category) {
  switch (category) {
    case Category.GENERAL:
      return "general";
    case Category.SHOP:
      return "shop";
    case Category.RESTAURANT:
      return "restaurant";
    case Category.GAS_STATION:
      return "gas_station";
    case Category.PORTABLE:
      return "portable";
    default:
      return "general";
  }
}

List<Widget> describeToiletIcons(
    Toilet toilet, String mode, bool isDetailed, bool smaller) {
  var result = new List<Widget>();
  EdgeInsets padding;
  String categoryStr = stringFromCategory(toilet.category);

  padding = EdgeInsets.fromLTRB(0, 0, 10.0, 0);

  // Add category icon
  result.add(
    descriptionIcon(
      padding,
      mode,
      smaller,
      null,
      iconPath: "assets/icons/bottom/$mode/cat_$categoryStr.svg",
    ),
  );

  // Loop over tags, add corresponding icons
  if (toilet.tags != null) {
    toilet.tags.forEach((Tag tag) {
      String tagStr = tag
          .toString()
          .substring(tag.toString().indexOf('.') + 1)
          .toLowerCase();
      result.add(
        descriptionIcon(
          padding,
          mode,
          smaller,
          null,
          iconPath: "assets/icons/bottom/$mode/tag_$tagStr.svg",
        ),
      );
    });
  }

  if (isDetailed) {
    if (toilet.entryMethod != EntryMethod.UNKNOWN) {
      result.add(
        entryMethodIconDetailed(
          toilet,
          padding,
        ),
      );
    }

    if (toilet.votes.length != 0) {
      int upvotes = 0;
      int downvotes = 0;

      toilet.votes.values.forEach((int value) {
        switch (value) {
          case 1:
            upvotes++;
            break;
          case -1:
            downvotes++;
            break;
        }
      });

      if (upvotes != 0 || downvotes != 0)
        result.add(
          descriptionIcon(
            padding,
            mode,
            smaller,
            '${((upvotes / (upvotes + downvotes)) * 100).round()}%',
            icon: Icons.thumb_up,
          ),
        );
    }
  } else {
    if (toilet.entryMethod != EntryMethod.UNKNOWN) {
      result.add(
        entryMethodIcon(
          toilet,
          padding,
          mode,
        ),
      );
    }
  }

  return result;
}

Future<BitmapDescriptor> determineMarkerIcon(
    Category category, List<int> openHours, BuildContext context) async {
  String result = "";

  result += stringFromCategory(category);
  result += openState(openHours);

  return await bitmapDescriptorFromSvgAsset(
    context,
    'assets/icons/pin/l_$result.svg',
  );
}

String minuteToHourFormat(int minutes) {
  String res = "";
  int hours = minutes ~/ 60;
  res += hours.toString();
  res += ':';
  res += '${minutes % 60}'.padLeft(2, '0');
  return res;
}

int hourToMinuteFormat(String input) {
  List<String> splitted = input.split(":");
  int hours = int.parse(splitted[0]);
  int minutes = int.parse(splitted[1]);
  return hours * 60 + minutes;
}
