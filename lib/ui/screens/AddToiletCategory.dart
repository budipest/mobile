import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../../core/models/Toilet.dart';
import '../widgets/Selectable.dart';

class AddToiletCategory extends StatelessWidget {
  const AddToiletCategory(
    this.onCategorySubmitted,
    this.selectedCategory,
  );

  final Function(Category) onCategorySubmitted;
  final Category selectedCategory;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
      children: <Widget>[
        Text(
          FlutterI18n.translate(context, "toiletType"),
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: Selectable(
            "cat_general.svg",
            FlutterI18n.translate(context, "general"),
            null,
            onCategorySubmitted,
            Category.GENERAL,
            selectedCategory == Category.GENERAL,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: Selectable(
            "cat_restaurant.svg",
            FlutterI18n.translate(context, "restaurant"),
            null,
            onCategorySubmitted,
            Category.RESTAURANT,
            selectedCategory == Category.RESTAURANT,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: Selectable(
            "cat_shop.svg",
            FlutterI18n.translate(context, "shop"),
            null,
            onCategorySubmitted,
            Category.SHOP,
            selectedCategory == Category.SHOP,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: Selectable(
            "cat_gas_station.svg",
            FlutterI18n.translate(context, "gasStation"),
            null,
            onCategorySubmitted,
            Category.GAS_STATION,
            selectedCategory == Category.GAS_STATION,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: Selectable(
            "cat_portable.svg",
            FlutterI18n.translate(context, "portable"),
            null,
            onCategorySubmitted,
            Category.PORTABLE,
            selectedCategory == Category.PORTABLE,
          ),
        ),
        Container(
          height: 80,
        ),
      ],
    );
  }
}
