import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/models/toilet.dart';
import './addToiletTitle.dart';
import './addToiletCategory.dart';

class AddToilet extends StatefulWidget {
  @override
  _AddToiletState createState() => _AddToiletState();
}

class _AddToiletState extends State<AddToilet> {
  PageController controller = PageController();
  LatLng location;
  String title;
  Category category;
  int selectedCategoryIndex;
  List<int> openHours;
  List<Tag> tags;

  void onTitleSubmitted(String text) {
    setState(() {
      title = text;
    });
  }

  void onCategorySubmitted(int index) {
    setState(() {
      selectedCategoryIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
            controller: controller,
            children: <Widget>[
              AddToiletTitle(onTitleSubmitted, controller, title),
              AddToiletCategory(onCategorySubmitted, selectedCategoryIndex),
            ],
          ),
          Container(
            decoration: BoxDecoration(color: Colors.black),
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 30, 30, 30),
              child: Stack(
                children: <Widget>[
                  RawMaterialButton(
                    shape: CircleBorder(),
                    fillColor: Colors.white,
                    elevation: 5.0,
                    constraints: BoxConstraints(),
                    padding: EdgeInsets.all(0),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 30.0,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 75, left: 4),
                    child: Text(
                      "Mosdó hozzáadása",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
