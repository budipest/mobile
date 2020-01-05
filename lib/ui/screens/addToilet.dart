import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';

import '../../core/viewmodels/ToiletModel.dart';
import '../../core/models/toilet.dart';
import './addToiletLocation.dart';
import './addToiletTitle.dart';
import './addToiletCategory.dart';
import './addToiletEntryMethod.dart';
import './addToiletOpenHours.dart';
import './addToiletTags.dart';

class AddToilet extends StatefulWidget {
  @override
  _AddToiletState createState() => _AddToiletState();
}

class _AddToiletState extends State<AddToilet> {
  final Location _location = new Location();

  GlobalKey headerKey = GlobalKey();

  PageController _controller;

  LatLng location;

  String title;

  Category category;

  EntryMethod entryMethod = EntryMethod.UNKNOWN;
  Map price = {"HUF": null};
  String code = "";
  bool hasEUR = false;

  List<int> openHours = new List<int>.filled(14, 0);

  List<Tag> tags = new List<Tag>();

  void onTitleSubmitted(String text) {
    setState(() {
      title = text;
    });
  }

  void onCategorySubmitted(Category newCategory) {
    setState(() {
      category = newCategory;
    });
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
        price["EUR"] = null;
      });
    }
  }

  void onPriceChanged(dynamic input, String currency) {
    setState(() {
      price[currency] = input;
    });
  }

  void onCodeSubmitted(String text) {
    setState(() {
      code = text;
    });
  }

  void onOpenHoursChanged(List<int> hours) {
    setState(() {
      openHours = hours;
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
    _controller.nextPage(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  double _getSizes() {
    if (headerKey.currentContext == null) {
      return 0;
    }
    final RenderBox renderBoxRed = headerKey.currentContext.findRenderObject();
    final size = renderBoxRed.size;
    return size.height - MediaQuery.of(context).padding.top;
  }

  void onFABPressed() async {
    final toiletProvider = Provider.of<ToiletModel>(context);

    if (_controller.offset > MediaQuery.of(context).size.width * 4.8) {
      var data = Toilet(
        new Uuid().toString(),
        GeoFirePoint(location.latitude, location.longitude),
        title,
        new DateTime.now(),
        category,
        openHours,
        tags,
        [],
        0,
        0,
        entryMethod,
        price,
        code,
      );
      await toiletProvider.uploadToilet(data);
      Navigator.of(context).pop();
    } else {
      nextPage();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: onFABPressed,
        backgroundColor: Colors.black,
        label: Text(FlutterI18n.translate(context, "continue")),
        icon: Icon(Icons.navigate_next),
      ),
      body: Stack(
        children: <Widget>[
          SafeArea(
            top: false,
            bottom: false,
            child: Padding(
              padding: EdgeInsets.only(
                top: _getSizes(),
              ),
              child: PageView(
                controller: _controller,
                pageSnapping: true,
                physics: _controller.hasClients
                    ? _controller.offset < 100
                        ? NeverScrollableScrollPhysics()
                        : null
                    : NeverScrollableScrollPhysics(),
                children: <Widget>[
                  FutureBuilder<Map<String, double>>(
                    future: _location.getLocation(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (location == null) {
                          location = LatLng(
                            snapshot.data["latitude"],
                            snapshot.data["longitude"],
                          );
                        }
                        return AddToiletLocation(onLocationChanged, location);
                      } else {
                        return Text(
                          "Töltjük a helyzetedet, egy pillanat türelmet",
                        );
                      }
                    },
                  ),
                  AddToiletTitle(onTitleSubmitted, _controller, title),
                  AddToiletCategory(onCategorySubmitted, category),
                  AddToiletEntryMethod(
                    onEntryMethodSubmitted,
                    entryMethod,
                    price,
                    onPriceChanged,
                    code,
                    onCodeSubmitted,
                    hasEUR,
                    toggleEUR,
                  ),
                  AddToiletOpenHours(onOpenHoursChanged, openHours),
                  AddToiletTags(onTagToggled, tags),
                ],
              ),
            ),
          ),
          Container(
            key: headerKey,
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
                        FlutterI18n.translate(context, "addToilet"),
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
  }
}
