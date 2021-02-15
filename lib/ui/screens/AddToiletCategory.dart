import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          AppLocalizations.of(context).toiletType,
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
            AppLocalizations.of(context).general,
            onCategorySubmitted,
            Category.GENERAL,
            selectedCategory == Category.GENERAL,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Selectable(
            "cat_restaurant.svg",
            AppLocalizations.of(context).restaurant,
            onCategorySubmitted,
            Category.RESTAURANT,
            selectedCategory == Category.RESTAURANT,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Selectable(
            "cat_shop.svg",
            AppLocalizations.of(context).shop,
            onCategorySubmitted,
            Category.SHOP,
            selectedCategory == Category.SHOP,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Selectable(
            "cat_gas_station.svg",
            AppLocalizations.of(context).gasStation,
            onCategorySubmitted,
            Category.GAS_STATION,
            selectedCategory == Category.GAS_STATION,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Selectable(
            "cat_portable.svg",
            AppLocalizations.of(context).portable,
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
