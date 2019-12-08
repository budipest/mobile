import 'package:flutter/material.dart';

import '../../core/models/toilet.dart';
import '../widgets/selectable.dart';

class AddToiletCategory extends StatelessWidget {
  const AddToiletCategory(this.onCategorySubmitted, this.selectedCategory);
  final Function(Category) onCategorySubmitted;
  final Category selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
      child: ListView(
        children: <Widget>[
          Text(
            "A mosdó típusa",
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
              "utcai WC",
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
              "étterem / kávézó",
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
              "bolt / áruház",
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
              "benzinkút",
              null,
              onCategorySubmitted,
              Category.GAS_STATION,
              selectedCategory == Category.GAS_STATION,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Selectable(
              "cat_temporary.svg",
              "mobil / ideiglenes WC",
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
      ),
    );
  }
}
