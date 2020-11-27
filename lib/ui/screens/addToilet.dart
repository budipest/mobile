import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
// import 'package:provider/provider.dart';

import '../../core/models/Toilet.dart';
import '../widgets/BlackLayoutContainer.dart';
import 'Home.dart';

import 'AddToiletLocation.dart';
import 'AddToiletName.dart';
import 'AddToiletCategory.dart';
import 'AddToiletEntryMethod.dart';
import 'AddToiletOpenHours.dart';
import 'AddToiletTags.dart';

class AddToilet extends StatefulWidget {
  const AddToilet(this.homeKey);
  final GlobalKey<HomeState> homeKey;

  @override
  _AddToiletState createState() => _AddToiletState();
}

class _AddToiletState extends State<AddToilet> {
  PageController _controller;

  LatLng location;
  String name;
  Category category;

  EntryMethod entryMethod = EntryMethod.UNKNOWN;
  Map price = {"HUF": null};
  String code = "";
  bool hasEUR = false;

  List<int> openHours = new List<int>.filled(14, 0);

  List<Tag> tags = new List<Tag>();

  void onNameChanged(String text) {
    setState(() {
      name = text;
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
          return name != null;
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
      FocusScope.of(context).requestFocus(FocusNode());
      _controller.nextPage(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  void onFABPressed() async {
    // final toiletProvider = Provider.of<ToiletModel>(context);

    if (_controller.offset > MediaQuery.of(context).size.width * 4.8) {
      var data = Toilet(
        "",
        name,
        new DateTime.now(),
        category,
        openHours,
        tags,
        entryMethod,
        price,
        code,
        location.latitude,
        location.longitude,
        [],
        new Map<String, int>(),
      );
      // TODO: implement adding a toilet
      // await toiletProvider.addToilet(data);
      widget.homeKey.currentState.selectToilet(data);
      Navigator.of(context).pop();
    } else {
      nextPage();
    }
  }

  @override
  void initState() {
    _controller = PageController();
    super.initState();
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
          AddToiletLocation(
            onLocationChanged,
            LatLng(
              widget.homeKey.currentState.locationData.latitude,
              widget.homeKey.currentState.locationData.longitude,
            ),
          ),
          AddToiletName(name, onNameChanged),
          AddToiletCategory(onCategoryChanged, category),
          AddToiletEntryMethod(
            onEntryMethodChanged,
            entryMethod,
            price,
            onPriceChanged,
            code,
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
