import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';

import '../../core/viewmodels/ToiletModel.dart';
import '../../core/models/toilet.dart';
import '../widgets/blackLayoutContainer.dart';
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

  void onTitleChanged(String text) {
    setState(() {
      title = text;
    });
  }

  void onCategoryChanged(Category newCategory) {
    setState(() {
      category = newCategory;
    });
  }

  void onEntryMethodChanged(EntryMethod entryMethodValue) {
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

  void onCodeChanged(String text) {
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

  bool validate() {
    int position =
        (_controller.offset / MediaQuery.of(context).size.width).round();

    switch (position) {
      case 1:
        {
          return title != null;
        }
      case 2:
        {
          return category != null;
        }
      case 3:
        {
          return entryMethod != EntryMethod.UNKNOWN;
        }
      default:
        {
          return true;
        }
    }
  }

  void nextPage() {
    if (validate()) {
      _controller.nextPage(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  void onFABPressed() async {
    final toiletProvider = Provider.of<ToiletModel>(context);

    if (_controller.offset > MediaQuery.of(context).size.width * 4.8) {
      var data = Toilet(
        new Uuid().v1(),
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
    return BlackLayoutContainer(
      context: context,
      title: FlutterI18n.translate(context, "addToilet"),
      fab: FloatingActionButton.extended(
        onPressed: onFABPressed,
        backgroundColor: Colors.black,
        label: Text(FlutterI18n.translate(context, "continue")),
        icon: Icon(Icons.navigate_next),
      ),
      child: PageView(
        controller: _controller,
        pageSnapping: true,
        physics: _controller.hasClients
            ? _controller.offset < 100 ? NeverScrollableScrollPhysics() : null
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
          AddToiletTitle(onTitleChanged),
          AddToiletCategory(onCategoryChanged, category),
          AddToiletEntryMethod(
            onEntryMethodChanged,
            entryMethod,
            price,
            onPriceChanged,
            onCodeChanged,
            hasEUR,
            toggleEUR,
          ),
          AddToiletOpenHours(onOpenHoursChanged, openHours),
          AddToiletTags(onTagToggled, tags),
        ],
      ),
    );
  }
}
