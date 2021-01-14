import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../core/models/Toilet.dart';
import '../../core/providers/ToiletModel.dart';
import '../widgets/BlackLayoutContainer.dart';

import 'AddToiletLocation.dart';
import 'AddToiletName.dart';
import 'AddToiletCategory.dart';
import 'AddToiletEntryMethod.dart';
import 'AddToiletOpenHours.dart';
import 'AddToiletTags.dart';

class AddToilet extends StatefulWidget {
  const AddToilet();

  @override
  _AddToiletState createState() => _AddToiletState();
}

class _AddToiletState extends State<AddToilet> {
  PageController _controller;

  LatLng location;
  String name;
  Category category;

  EntryMethod entryMethod = EntryMethod.UNKNOWN;
  Map<String, int> price = {"HUF": null};
  String code = "";
  bool hasEUR = false;

  List<int> openHours = List<int>.filled(14, 0);
  bool isNonStop = false;

  List<Tag> tags = List<Tag>.empty(growable: true);

  bool isLoading = false;

  int lastValidated = 1;
  bool isOnLastScreen = false;

  void onNameChanged(String text) {
    setState(() {
      name = text;
    });

    validatePage();
  }

  void onCategoryChanged(Category newCategory) {
    setState(() {
      category = newCategory;
    });

    validatePage();
  }

  void onEntryMethodChanged(EntryMethod entryMethodValue) {
    setState(() {
      entryMethod = entryMethodValue;
    });

    validatePage();
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

    validatePage();
  }

  void onPriceChanged(String input, String currency) {
    if (input.length > 0) {
      setState(() {
        price[currency] = int.parse(input);
      });
    } else {
      setState(() {
        price[currency] = null;
      });
    }

    validatePage();
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

  void onNonStopChanged(bool nonStop) {
    setState(() {
      isNonStop = nonStop;
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

  bool validate(int position) {
    switch (position) {
      case 1:
        {
          return name != null &&
              name.length > 2 &&
              name.replaceAll(" ", "").length > 2;
        }
      case 2:
        {
          return category != null;
        }
      case 3:
        {
          if (entryMethod == EntryMethod.UNKNOWN) {
            return false;
          }

          if (entryMethod == EntryMethod.PRICE) {
            if (price["HUF"] == null) {
              return false;
            }

            if (hasEUR && price["EUR"] == null) {
              return false;
            }
          }

          return true;
        }
      default:
        {
          return true;
        }
    }
  }

  void validatePage() {
    int lastValidPosition = 4;

    for (int i = 1; i < 4; i++) {
      if (!validate(i)) {
        lastValidPosition = i;
        break;
      }
    }

    if (lastValidPosition > 3) {
      setState(() {
        lastValidated = 5;
      });
    } else {
      setState(() {
        lastValidated = lastValidPosition;
      });
    }
  }

  void previousPage() {
    FocusScope.of(context).requestFocus(FocusNode());
    _controller.previousPage(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  void nextPage(ToiletModel provider) {
    int position =
        (_controller.offset / MediaQuery.of(context).size.width).floor();

    if (validate(position)) {
      FocusScope.of(context).requestFocus(FocusNode());

      _controller.nextPage(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    } else {
      provider.showErrorSnackBar("error.requiredFields");
    }
  }

  void addToilet(ToiletModel provider) async {
    Toilet data = Toilet.createNew(
      name,
      provider.userId,
      category,
      isNonStop ? [0, 1440] : openHours,
      tags,
      entryMethod,
      price,
      code,
      location.latitude,
      location.longitude,
    );

    bool isValid = true;

    for (int i = 1; i < 4; i++) {
      if (!validate(i)) {
        isValid = false;
      }
    }

    if (isValid) {
      setState(() {
        isLoading = true;
      });

      try {
        await provider.addToilet(data);
      } catch (error) {
        print(error);
        Navigator.of(context).pop();
      }

      setState(() {
        isLoading = false;
      });

      Navigator.of(context).pop();
    } else {
      provider.showErrorSnackBar("error.missingFields");
    }
  }

  void onFABPressed(ToiletModel provider) {
    if (isOnLastScreen) {
      addToilet(provider);
    } else {
      nextPage(provider);
    }
  }

  void updateScreenState(int index) {
    setState(() {
      isOnLastScreen = index == 5;
    });
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
    final provider = Provider.of<ToiletModel>(context, listen: false);
    final dimensions = MediaQuery.of(context).size;

    if (location == null) {
      location = LatLng(
        provider.location.latitude,
        provider.location.longitude,
      );
    }

    final List<Widget> allScreens = [
      AddToiletLocation(onLocationChanged, location),
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
      AddToiletOpenHours(
        onOpenHoursChanged,
        onNonStopChanged,
        openHours,
        isNonStop,
      ),
      AddToiletTags(onTagToggled, tags),
    ];

    final List<Widget> screens =
        allScreens.getRange(0, lastValidated + 1).toList();

    return WillPopScope(
      onWillPop: () async {
        if (_controller.offset == 0) {
          return true;
        } else {
          previousPage();
          return false;
        }
      },
      child: Stack(
        children: [
          BlackLayoutContainer(
            context: context,
            title: FlutterI18n.translate(context, "addToilet"),
            fab: FloatingActionButton.extended(
              onPressed: () => onFABPressed(provider),
              backgroundColor: Colors.black,
              label: Text(
                FlutterI18n.translate(
                  context,
                  isOnLastScreen ? "addToilet" : "continue",
                ),
              ),
              icon: Icon(Icons.navigate_next),
            ),
            child: PageView(
              controller: _controller,
              pageSnapping: true,
              physics: _controller.hasClients
                  ? _controller.offset < 5
                      ? NeverScrollableScrollPhysics()
                      : null
                  : NeverScrollableScrollPhysics(),
              onPageChanged: updateScreenState,
              children: screens,
            ),
          ),
          isLoading
              ? Stack(
                  children: [
                    Opacity(
                      opacity: 0.5,
                      child: Container(
                        color: Colors.black,
                        width: dimensions.width,
                        height: dimensions.height,
                      ),
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(45),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
