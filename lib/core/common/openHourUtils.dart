import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import 'dart:async';
import 'dart:core';

import '../models/Toilet.dart';
import '../models/Vote.dart';
import 'bitmapFromSvg.dart';
import "variables.dart";

enum OpenState { OPEN, CLOSED, UNKNOWN }

class OpenStateDetails {
  OpenState state;
  String first;
  String second;
  Color color;
  List<int> raw;

  OpenStateDetails(this.raw);

  updateState(BuildContext context) {
    if (this.raw.every((element) => element == 0)) {
      state = OpenState.UNKNOWN;
      color = Colors.grey;
      first = FlutterI18n.translate(context, "unknown");
      second = "";
      return;
    }

    if (this.raw[0] == 0 && this.raw[1] == 1440 && this.raw.length == 2) {
      state = OpenState.OPEN;
      color = Colors.green;
      first = FlutterI18n.translate(context, "open");
      second = "24/7";
      return;
    }

    DateTime dateTime = DateTime.now();

    // current minute of day
    int currentTime = (dateTime.hour * 60) + dateTime.minute;
    // 0 - Monday -- 6 - Sunday
    int currentDayIndex = dateTime.weekday - 1;
    int currentlyPast = -2;

    int yesterdayLastIndex = handleDayIndexOverflow((currentDayIndex * 2) - 1);
    int todayFirstIndex = handleDayIndexOverflow(currentDayIndex * 2);
    int todayLastIndex = handleDayIndexOverflow((currentDayIndex * 2) + 1);

    int yesterdayLast = this.raw[yesterdayLastIndex];
    int todayFirst = this.raw[todayFirstIndex];
    int todayLast = this.raw[todayLastIndex];

    // "regular hours" are, for example: 8AM-4PM (cafe)
    // "irregular" or "overnight" hours are, for example: 8PM-4AM (bar)
    bool regularHours =
        (todayFirst < todayLast) || (yesterdayLast > todayFirst);

    if (regularHours) {
      if (todayFirst < currentTime && currentTime < todayLast) {
        state = OpenState.OPEN;
        color = Colors.green;
        first = FlutterI18n.translate(context, "open");
        currentlyPast = todayFirstIndex;
      } else {
        state = OpenState.CLOSED;
        color = Colors.red;
        first = FlutterI18n.translate(context, "closed");

        if (todayFirst > currentTime) {
          currentlyPast = yesterdayLastIndex;
        } else if (todayLast < currentTime) {
          currentlyPast = todayLastIndex;
        }
      }
    } else {
      if (yesterdayLast < currentTime ||
          currentTime < todayFirst ||
          todayLast < currentTime) {
        state = OpenState.OPEN;
        color = Colors.green;
        first = FlutterI18n.translate(context, "open");
        if (todayLast < currentTime) {
          currentlyPast = todayLastIndex;
        } else {
          currentlyPast = yesterdayLastIndex;
        }
      } else {
        state = OpenState.CLOSED;
        color = Colors.red;
        first = FlutterI18n.translate(context, "closed");
        currentlyPast = todayFirstIndex;
      }
    }

    if (todayFirst == 0 && todayLast == 0) {
      state = OpenState.CLOSED;
      color = Colors.red;
      first = FlutterI18n.translate(context, "closed");
      currentlyPast = -2;
    }

    for (int i = currentlyPast + 1; second == null; i++) {
      i = handleDayIndexOverflow(i);

      bool isFirstValueToday = i % 2 == 0;

      if (this.raw[i] != 0 ||
          (isFirstValueToday && this.raw[handleDayIndexOverflow(i + 1)] != 0)) {
        String time = minuteToHourFormat(this.raw[i]);
        String localeKey;
        int dayIndex = (i / 2).floor();

        if (dayIndex == currentDayIndex) {
          // today
          localeKey = "todayUntil";
        } else if (dayIndex == handleDayOverflow(currentDayIndex + 1)) {
          // tomorrow
          localeKey = "tomorrowUntil";
        } else {
          // other day
          localeKey = "until";
        }

        second = FlutterI18n.translate(
          context,
          localeKey,
          translationParams: Map.fromIterables(
            ["time", "day"],
            [time, FlutterI18n.translate(context, days[dayIndex])],
          ),
        );
      }
    }
  }
}

int handleDayOverflow(int i) {
  // Sunday => Monday overflow
  if (i > 6) {
    i -= 7;
  } else if (i < 0) {
    i += 7;
  }

  return i;
}

int handleDayIndexOverflow(int i) {
  // Sunday => Monday overflow
  if (i > 13) {
    i -= 14;
  } else if (i < 0) {
    i += 14;
  }

  return i;
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

Widget descriptionIcon(
  EdgeInsetsGeometry padding,
  String mode,
  bool smaller,
  String text, {
  String iconPath,
  IconData icon,
}) {
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

List<Widget> describeToiletIcons(
    Toilet toilet, String mode, bool isDetailed, bool smaller) {
  var result = List<Widget>();

  if (toilet == null) {
    return result;
  }

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

      toilet.votes.forEach((Vote vote) {
        switch (vote.value) {
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
  Category category,
  OpenState openState,
  BuildContext context,
) async {
  String result = "";

  result += stringFromCategory(category);
  result += "_";
  result += openState
      .toString()
      .substring(openState.toString().indexOf('.') + 1)
      .toLowerCase();

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
