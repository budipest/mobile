import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
      children: <Widget>[
        Text(
          "toiletType",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Selectable(
            "cat_general.svg",
            "general",
            onCategorySubmitted,
            Category.GENERAL,
            selectedCategory == Category.GENERAL,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Selectable(
            "cat_restaurant.svg",
            "restaurant",
            onCategorySubmitted,
            Category.RESTAURANT,
            selectedCategory == Category.RESTAURANT,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Selectable(
            "cat_shop.svg",
            "shop",
            onCategorySubmitted,
            Category.SHOP,
            selectedCategory == Category.SHOP,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Selectable(
            "cat_gas_station.svg",
            "gasStation",
            onCategorySubmitted,
            Category.GAS_STATION,
            selectedCategory == Category.GAS_STATION,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Selectable(
            "cat_portable.svg",
            "portable",
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
