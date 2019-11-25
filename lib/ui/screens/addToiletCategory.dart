import 'package:flutter/material.dart';

import '../../core/models/toilet.dart';
import '../widgets/selectable.dart';

class AddToiletCategory extends StatelessWidget {
  const AddToiletCategory(this.onCategorySubmitted, this.selectedCategoryIndex);
  final Function(int) onCategorySubmitted;
  final int selectedCategoryIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30, 200, 30, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            child: Selectable(Icons.ac_unit, "utcai WC", null,
                onCategorySubmitted, 0, selectedCategoryIndex == 0),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Selectable(Icons.ac_unit, "étterem / kávézó", null,
                onCategorySubmitted, 1, selectedCategoryIndex == 1),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Selectable(Icons.ac_unit, "bolt / áruház", null,
                onCategorySubmitted, 2, selectedCategoryIndex == 2),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Selectable(Icons.ac_unit, "benzinkút", null,
                onCategorySubmitted, 3, selectedCategoryIndex == 3),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Selectable(Icons.ac_unit, "mobilr WC", null,
                onCategorySubmitted, 4, selectedCategoryIndex == 4),
          ),
        ],
      ),
    );
  }
}