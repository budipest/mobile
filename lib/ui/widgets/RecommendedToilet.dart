import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import "Button.dart";
import "BottomBarBlackContainer.dart";
import '../../core/common/openHourUtils.dart';
import '../../core/models/Toilet.dart';
import '../../core/providers/ToiletModel.dart';

class RecommendedToilet extends StatelessWidget {
  const RecommendedToilet(this.scrollProgress);

  final double scrollProgress;

  void _navigate(Toilet toilet) async {
    String url = Platform.isIOS
        ? 'https://maps.apple.com/?q=${toilet.latitude},${toilet.longitude}'
        : 'https://www.google.com/maps/search/?api=1&query=${toilet.latitude},${toilet.longitude}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("error while launching $url");
      // error in launching map
      // TODO: handle error
    }
  }

  void _tooFarNavigate(BuildContext context, Toilet toilet) {
    final provider = Provider.of<ToiletModel>(context, listen: false);

    int index = provider.toilets.indexOf(provider.selectedToilet);

    if (index > 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text(
              FlutterI18n.translate(context, "notGonnaGetThere"),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            content: Text(
              FlutterI18n.plural(context, "closerToilets.numOfToilets", index),
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              FlatButton(
                child: Text(FlutterI18n.translate(context, "cancel")),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(FlutterI18n.translate(context, "directions")),
                onPressed: () {
                  _navigate(toilet);
                },
              ),
            ],
          );
        },
      );
    } else {
      _navigate(toilet);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Toilet selectedToilet =
        context.select((ToiletModel m) => m.selectedToilet);
    final Toilet suggestedToilet =
        context.select((ToiletModel m) => m.suggestedToilet);
    final Function selectToilet =
        context.select((ToiletModel m) => m.selectToilet);
    final bool hasLocationPermission =
        context.select((ToiletModel m) => m.hasLocationPermission);

    final List<String> openingTimes = new List<String>.empty(growable: true);

    bool hasSelected = selectedToilet != null;

    if (hasSelected) {
      // setup first and second opening time strings
      OpenStateDetails openState = selectedToilet.openState;

      openingTimes.add(FlutterI18n.translate(
            context,
            openState.first,
          ) +
          " ");

      if (openState.secondKey != null) {
        Map params = openState.secondParams;

        params["day"] = FlutterI18n.translate(context, params["day"]);

        openingTimes.add(FlutterI18n.translate(
          context,
          openState.secondKey,
          translationParams: Map.from(openState.secondParams),
        ));
      } else {
        openingTimes.add(openState.secondString);
      }
    }

    return BottomBarBlackContainer(
      scrollProgress,
      () {
        if (!hasSelected) {
          selectToilet(suggestedToilet);
        }
      },
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: "inlineTitle",
            flightShuttleBuilder: (
              BuildContext flightContext,
              Animation<double> animation,
              HeroFlightDirection flightDirection,
              BuildContext fromHeroContext,
              BuildContext toHeroContext,
            ) =>
                Material(
              color: Colors.transparent,
              child: toHeroContext.widget,
            ),
            child: SizedBox(
              child: Text(
                hasSelected
                    ? selectedToilet.name
                    : FlutterI18n.translate(
                        context,
                        "recommendedToilet",
                      ),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Muli",
                ),
              ),
            ),
          ),
          Container(height: 8),
          Wrap(
            direction: Axis.horizontal,
            runSpacing: 7.5,
            children: <Widget>[
              ...describeToiletIcons(
                hasSelected ? selectedToilet : suggestedToilet,
                "dark",
                hasSelected,
                hasSelected,
              ),
              if (!hasSelected)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      hasSelected ? selectedToilet.name : suggestedToilet.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      hasSelected
                          ? selectedToilet.distanceString
                          : suggestedToilet.distanceString,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.0,
                      ),
                    )
                  ],
                )
            ],
          ),
          if (hasSelected)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'Muli',
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: openingTimes[0],
                        ),
                        TextSpan(
                          text: openingTimes[1],
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (hasLocationPermission)
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontFamily: 'Muli',
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: selectedToilet.distance < 10000
                                ? selectedToilet.distanceString
                                : FlutterI18n.translate(
                                    context,
                                    "tooFar",
                                  ),
                          ),
                          TextSpan(
                            text: FlutterI18n.translate(
                              context,
                              "distanceFromYou",
                            ),
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          if (hasSelected)
            Row(
              children: <Widget>[
                Expanded(
                  child: Button(
                    FlutterI18n.translate(context, "directions"),
                    () {
                      if (selectedToilet.distance < 10000) {
                        _navigate(selectedToilet);
                      } else {
                        _tooFarNavigate(context, selectedToilet);
                      }
                    },
                    icon: Icons.navigation,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                ),
                // TODO: implement suggesting toilet data modifications
                // Padding(
                //   padding: const EdgeInsets.only(left: 12.0),
                //   child: Button(
                //     "",
                //     () => {print("not implemented yet")},
                //     icon: Icons.edit,
                //     backgroundColor: Colors.transparent,
                //     foregroundColor: Colors.white,
                //     isBordered: true,
                //   ),
                // ),
              ],
            ),
        ],
      ),
    );
  }
}
