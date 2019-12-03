import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../core/models/toilet.dart';
import './addToiletLocation.dart';
import './addToiletTitle.dart';
import './addToiletCategory.dart';
import './addToiletEntryMethod.dart';
import './addToiletTags.dart';

class AddToilet extends StatefulWidget {
  @override
  _AddToiletState createState() => _AddToiletState();
}

class _AddToiletState extends State<AddToilet> {
  final Location _location = new Location();

  PageController controller = PageController();

  LatLng location;

  String title;

  Category category;
  int selectedCategoryIndex;

  EntryMethod entryMethod = EntryMethod.UNKNOWN;
  Map price = {"HUF": 0};
  String code = "";
  bool hasEUR = false;

  List<int> openHours;

  List<Tag> tags = new List<Tag>();

  void onTitleSubmitted(String text) {
    setState(() {
      title = text;
    });
    nextPage();
  }

  void onCategorySubmitted(int index) {
    setState(() {
      selectedCategoryIndex = index;
    });
    nextPage();
  }

  void onEntryMethodSubmitted(EntryMethod entryMethodValue) {
    setState(() {
      entryMethod = entryMethodValue;
    });
  }

  void toggleEUR() {
    if (hasEUR) {
      setState(() {
        hasEUR = false;
        price["EUR"] = null;
      });
    } else {
      setState(() {
        hasEUR = true;
        price["EUR"] = 0;
      });
    }
  }

  // void onPriceSubmitted(Map input) {
  //   setState(() {
  //     price = input;
  //   });
  // }

  void onPriceSubmitted(dynamic input, String currency) {
    setState(() {
      price[currency] = input;
    });
  }

  void onCodeSubmitted(String text) {
    setState(() {
      code = text;
    });
  }

  void onTagToggled(int input) {
    Tag tag = input == 0 ? Tag.WHEELCHAIR_ACCESSIBLE : Tag.BABY_ROOM;
    setState(() {
      tags.contains(tag) ? tags.remove(tag) : tags.add(tag);
    });
  }

  void onLocationChanged(LatLng coords) {
    setState(() {
      location = coords;
    });
  }

  void nextPage() {
    controller.nextPage(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, double>>(
      future: _location.getLocation(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (location == null) {
            setState(() {
              location =
                  LatLng(snapshot.data["latitude"], snapshot.data["longitude"]);
            });
          }

          return Scaffold(
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => nextPage(),
              backgroundColor: Colors.black,
              label: Text("Tovább"),
              icon: Icon(Icons.navigate_next),
            ),
            body: Stack(
              children: <Widget>[
                SafeArea(
                  bottom: false,
                  child: PageView(
                    physics: controller.offset < 100
                        ? NeverScrollableScrollPhysics()
                        : null,
                    pageSnapping: true,
                    controller: controller,
                    children: <Widget>[
                      AddToiletLocation(onLocationChanged, location),
                      AddToiletTitle(onTitleSubmitted, controller, title),
                      AddToiletCategory(
                          onCategorySubmitted, selectedCategoryIndex),
                      AddToiletEntryMethod(
                        onEntryMethodSubmitted,
                        entryMethod,
                        price,
                        onPriceSubmitted,
                        code,
                        onCodeSubmitted,
                        hasEUR,
                        toggleEUR,
                      ),
                      AddToiletTags(onTagToggled, tags),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(color: Colors.black),
                  width: MediaQuery.of(context).size.width,
                  child: SafeArea(
                    bottom: false,
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
                ),
              ],
            ),
          );
        } else {
          return Text("várj még egy picit, keresünk téged");
        }
      },
    );
  }
}
