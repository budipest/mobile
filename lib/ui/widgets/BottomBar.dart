import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import 'Button.dart';
import 'ToiletDetailBar.dart';
import 'ToiletRecommendationList.dart';
import '../../core/common/openHourUtils.dart';
import '../../core/models/Toilet.dart';
import '../../core/providers/ToiletModel.dart';

class BottomBar extends StatelessWidget {
  const BottomBar(
    this.scrollProgress,
    this.sc,
  );
  final double scrollProgress;
  final ScrollController sc;

  void _navigate(Toilet toilet) async {
    String url = Platform.isIOS
        ? 'https://maps.apple.com/?q=${toilet.latitude},${toilet.longitude}'
        : 'https://www.google.com/maps/search/?api=1&query=${toilet.latitude},${toilet.longitude}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("error while launching $url");
      // error in launching map
      // TOOD: handle error
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
            title: new Text(
              FlutterI18n.translate(context, "notGonnaGetThere"),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            content: new Text(
              FlutterI18n.plural(context, "closerToilets.numOfToilets", index),
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: Text(FlutterI18n.translate(context, "cancel")),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
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
    final provider = Provider.of<ToiletModel>(context);
    final Toilet selectedToilet = provider.selectedToilet;
    final Toilet suggestedToilet = provider.suggestedToilet;

    bool hasSelected = selectedToilet != null;

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(
        controller: sc,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Colors.black,
            width: MediaQuery.of(context).size.width,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (!hasSelected)
                  provider.selectToilet(provider.suggestedToilet);
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Opacity(
                      opacity: 1 - scrollProgress,
                      child: Center(
                        child: Container(
                          height: 4,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(40.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        0,
                        ((MediaQuery.of(context).padding.top + 60) *
                                scrollProgress) +
                            15.0,
                        0,
                        7.5,
                      ),
                      child: Hero(
                        tag: "inlineTitle",
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
                          ),
                        ),
                      ),
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      runSpacing: 7.5,
                      children: <Widget>[
                        ...(hasSelected
                            ? describeToiletIcons(
                                selectedToilet,
                                "dark",
                                true,
                                true,
                              )
                            : describeToiletIcons(
                                suggestedToilet,
                                "dark",
                                false,
                                false,
                              )),
                        if (!hasSelected)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                hasSelected
                                    ? selectedToilet.name
                                    : suggestedToilet.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                hasSelected
                                    ? "${selectedToilet.distance} m"
                                    : "${suggestedToilet.distance} m",
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
                                      text: readableOpenState(
                                    selectedToilet.openHours,
                                    context,
                                  )[0]),
                                  TextSpan(
                                    text: readableOpenState(
                                      selectedToilet.openHours,
                                      context,
                                    )[1],
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                                        ? '${selectedToilet.distance} m'
                                        : FlutterI18n.translate(
                                            context, "tooFar"),
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
                          //   padding: EdgeInsets.only(left: 12.0),
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
                      )
                  ],
                ),
              ),
            ),
          ),
          hasSelected
              ? ToiletDetailBar(selectedToilet)
              : ToiletRecommendationList()
        ],
      ),
    );
  }
}
