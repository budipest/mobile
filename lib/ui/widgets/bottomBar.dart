import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:io' show Platform;

import './button.dart';
import './toiletDetailBar.dart';
import './toiletRecommendationList.dart';
import '../../core/common/openHourUtils.dart';
import '../../core/models/toilet.dart';

class BottomBar extends StatelessWidget {
  const BottomBar(this.toilets, this.scrollProgress, this.selectedToilet,
      this.selectToilet);
  final List<Toilet> toilets;
  final Toilet selectedToilet;
  final double scrollProgress;
  final Function(Toilet) selectToilet;

  @override
  Widget build(BuildContext context) {
    bool hasSelected = selectedToilet != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          color: Colors.black,
          width: MediaQuery.of(context).size.width,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (!hasSelected) selectToilet(toilets[0]);
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
                    child: Text(
                      hasSelected
                          ? selectedToilet.title
                          : FlutterI18n.translate(context, "recommendedToilet"),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
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
                              toilets[0],
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
                                  ? selectedToilet.title
                                  : toilets[0].title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              hasSelected
                                  ? "${selectedToilet.distance} m"
                                  : "${toilets[0].distance} m",
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
                                TextSpan(text: '${selectedToilet.distance} m'),
                                TextSpan(
                                  text: FlutterI18n.translate(
                                      context, "distanceFromYou"),
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
                          child: Padding(
                            padding: EdgeInsets.only(right: 12.0),
                            child: Button(
                              FlutterI18n.translate(context, "navigate"),
                              () async {
                                String url = Platform.isIOS
                                    ? 'https://maps.apple.com/?q=${selectedToilet.geopoint.latitude},${selectedToilet.geopoint.longitude}'
                                    : 'https://www.google.com/maps/search/?api=1&query=${selectedToilet.geopoint.latitude},${selectedToilet.geopoint.longitude}';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  print("error while launching $url");
                                  // error in launching map
                                  // TOOD: handle error
                                }
                              },
                              icon: Icons.navigation,
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                            ),
                          ),
                        ),
                        Button(
                          "",
                          () => {print("fasz")},
                          icon: Icons.edit,
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          isBordered: true,
                        ),
                      ],
                    )
                ],
              ),
            ),
          ),
        ),
        hasSelected
            ? ToiletDetailBar(selectedToilet)
            : ToiletRecommendationList(
                toilets.sublist(1, toilets.length - 1), selectToilet)
      ],
    );
  }
}
