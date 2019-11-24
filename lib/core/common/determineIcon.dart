import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'dart:async';

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

List<Widget> describeToiletIcons(Toilet toilet, String mode) {
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
      child: SvgPicture.asset("assets/icons/bottom/$mode/cat_$categoryStr.svg",
          semanticsLabel: '$categoryStr category icon', width: 35, height: 35),
    ),
  );

  // Loop over tags, add corresponding icons
  toilet.tags.forEach((Tag tag) {
    String tagStr = tag.toString().toLowerCase().substring(4);
    result.add(
      Padding(
        padding: padding,
        child: SvgPicture.asset("assets/icons/bottom/$mode/tag_$tagStr.svg",
            semanticsLabel: '$tagStr tag icon', width: 35, height: 35),
      ),
    );
  });

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
