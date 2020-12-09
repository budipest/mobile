import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import 'dart:async';
import 'dart:core';

import '../models/Toilet.dart';
import '../models/Vote.dart';
import 'bitmapFromSvg.dart';

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
  DateTime dateTime = DateTime.now();

  int curr = (dateTime.hour * 60) + dateTime.minute; // current minute of day
  int start = 0; // today's starting time index
  int end = 1; // today's ending time index

  if (openHours.length > 2) {
    start = (dateTime.weekday - 1) * 2;
    end = start + 1;
  }

  bool regularHours = openHours[start] < openHours[end];
  bool pastOpening = openHours[start] < curr;
  bool pastClosing = openHours[end] < curr;

  if (openHours.every((element) => element == 0)) {
    return "_unknown";
  }

  if (regularHours) {
    // if it has a regular opening time, e.g. 8AM-9PM
    if (pastOpening && !pastClosing) {
      // if it's past opening but before closing time
      return "_open";
    } else if (!pastOpening || pastClosing) {
      // if it's before opening or past closing time
      return "_closed";
    }
  } else {
    // if it has an overnight opening time, e.g. 10PM-2AM
    // opening: 10PM
    // closing: 2AM
    // current: 11PM. pastOpening, pastClosing
    // current: 1AM. !pastOpening, !pastClosing
    if (!pastOpening && !pastClosing || pastOpening && pastClosing) {
      return "_open";
    } else if (pastOpening && !pastClosing || !pastOpening && pastClosing) {
      return "_closed";
    }
  }

  return "_unknown";
}

bool isOpen(List<int> openHours) {
  if (openState(openHours) == "_open") {
    return true;
  }
  return false;
}

Color coloredOpenState(List<int> openHours) {
  switch (openState(openHours)) {
    case "_open":
      return Colors.green;
    case "_closed":
      return Colors.red;
    default:
      return Colors.grey;
  }
}

List<String> readableOpenState(List<int> openHours, BuildContext context) {
  DateTime dateTime = DateTime.now();
  int curr = (dateTime.hour * 60) + dateTime.minute;
  int start = 0;
  int end = 1;

  if (openHours.length > 2) {
    start = (dateTime.weekday - 1) * 2;
    end = start + 1;
  }

  bool regularHours = openHours[start] < openHours[end];
  bool pastOpening = openHours[start] < curr;
  bool pastClosing = openHours[end] < curr;

  switch (openState(openHours)) {
    case "_open":
      return [
        FlutterI18n.translate(context, "open") + " ",
        openHours[0] == 0 && openHours[1] == 1440
            ? "24/7"
            : FlutterI18n.translate(
                context,
                "todayUntil",
                translationParams: Map.fromIterables(
                  ["time"],
                  [minuteToHourFormat(openHours[end])],
                ),
              ),
      ];

    // TODO: investigate this thing
    case "_closed":
      return [
        FlutterI18n.translate(context, "closed") + " ",
        regularHours
            ? pastClosing
                ? FlutterI18n.translate(
                    context,
                    "tomorrowUntil",
                    translationParams: Map.fromIterables(
                      ["time"],
                      end > 1
                          ? [
                              minuteToHourFormat(
                                  openHours[start + 1 >= 14 ? 0 : start])
                            ]
                          : [minuteToHourFormat(openHours[start])],
                    ),
                  )
                : FlutterI18n.translate(
                    context,
                    "todayUntil",
                    translationParams: Map.fromIterables(
                      ["time"],
                      [
                        minuteToHourFormat(
                          openHours[start],
                        ),
                      ],
                    ),
                  )
            : pastOpening
                ? FlutterI18n.translate(
                    context,
                    "todayUntil",
                    translationParams: Map.fromIterables(
                      ["time"],
                      start > 1
                          ? [
                              minuteToHourFormat(
                                  openHours[end + 1 >= 14 ? 0 : end])
                            ]
                          : [minuteToHourFormat(openHours[end])],
                    ),
                  )
                : FlutterI18n.translate(
                    context,
                    "tomorrowUntil",
                    translationParams: Map.fromIterables(
                      ["time"],
                      [
                        minuteToHourFormat(
                          openHours[start],
                        ),
                      ],
                    ),
                  )
      ];

    default:
      return [FlutterI18n.translate(context, "unknown"), ""];
  }
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
