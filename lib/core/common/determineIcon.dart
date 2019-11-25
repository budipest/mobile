import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'dart:async';
import 'dart:core';

import '../models/toilet.dart';
import './bitmapFromSvg.dart';

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

List<String> readableOpenState(List<int> openHours) {
  List<String> result = [];
  if (openHours[0] >= openHours[1]) {
    result.add("Ismeretlen nyitvatartási idő");
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
    result.add("Nyitva ");
    if (openHours.length == 2) {
      result.add("24/7");
    } else {
      result.add("${minuteToHourFormat(openHours[end])}-ig");
    }
  } else {
    result.add("Zárva ");
    if (openHours[start] > curr) {
      result.add("ma ${minuteToHourFormat(openHours[start])}-ig");
    } else {
      if (end > 1) {
        result.add("holnap ${minuteToHourFormat(openHours[end + 1])}-ig");
      } else {
        result.add("holnap ${minuteToHourFormat(openHours[start])}-ig");
      }
    }
  }

  return result;
}

String minuteToHourFormat(int minutes) {
  String res = "";
  int hours = minutes ~/ 60;
  res += hours.toString();
  res += ':';
  res += '${minutes % 60}'.padLeft(2, '0');
  return res;
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

  if (mode == "light") {
    padding = EdgeInsets.fromLTRB(0, 0, 10.0, 0);
  } else {
    padding = EdgeInsets.fromLTRB(10.0, 0, 0, 0);
  }

  // Add category icon
  result.add(
    Padding(
      padding: padding,
      child: SvgPicture.asset(
        "assets/icons/bottom/$mode/cat_$categoryStr.svg",
        semanticsLabel: '$categoryStr category icon',
        width: smaller ? 27.5 : 35,
        height: smaller ? 27.5 : 35,
      ),
    ),
  );

  // Loop over tags, add corresponding icons
  toilet.tags.forEach((Tag tag) {
    String tagStr = tag.toString().toLowerCase().substring(4);
    result.add(
      Padding(
        padding: padding,
        child: SvgPicture.asset(
          "assets/icons/bottom/$mode/tag_$tagStr.svg",
          semanticsLabel: '$tagStr tag icon',
          width: 35,
          height: 35,
        ),
      ),
    );
  });

  if (isDetailed) {
    result.add(
      Text(
        '${toilet.price.toString()} Ft',
        style: TextStyle(
          color: Colors.white,
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    if(toilet.upvotes != 0 || toilet.downvotes != 0)
    result.add(
      Text(
        '${((toilet.upvotes / (toilet.upvotes + toilet.downvotes)) * 100).round()}%',
        style: TextStyle(
          color: Colors.white,
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  return result;
}

Future<BitmapDescriptor> determineMarkerIcon(
    Category category, List<int> openHours, BuildContext context) async {
  String result = "";

  result += stringFromCategory(category);
  result += openState(openHours);

  return await bitmapDescriptorFromSvgAsset(
      context, 'assets/icons/pin/l_$result.svg');
}
