import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:io' show Platform;

import './button.dart';
import './toiletDetailBar.dart';
import './toiletRecommendationList.dart';
import '../../core/common/determineIcon.dart';
import '../../core/models/toilet.dart';

class BottomBar extends StatelessWidget {
  BottomBar(this.toilets, this.scrollProgress, this.selectedToilet,
      this.selectToilet);
  final List<Toilet> toilets;
  final Toilet selectedToilet;
  final double scrollProgress;
  final Function(Toilet) selectToilet;
  bool hasSelected = false;

  @override
  Widget build(BuildContext context) {
    hasSelected = selectedToilet != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          color: Colors.black,
          width: MediaQuery.of(context).size.width,
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
                      7.5),
                  child: Text(
                    hasSelected ? selectedToilet.title : "Ajánlott mosdó",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
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
                                      selectedToilet.openHours)[0]),
                              TextSpan(
                                text: readableOpenState(
                                    selectedToilet.openHours)[1],
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
                                text: '-re tőled',
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
                            "Navigáció",
                            () async {
                              print("navigáció it is.");
                              String url = Platform.isIOS
                                  ? 'https://maps.apple.com/?q=${selectedToilet.geopoint.latitude},${selectedToilet.geopoint.longitude}'
                                  : 'https://www.google.com/maps/search/?api=1&query=${selectedToilet.geopoint.latitude},${selectedToilet.geopoint.longitude}';
                              print(url);
                              if (await canLaunch(url)) {
                                await launch(url);
                                print("launched $url");
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
        hasSelected
            ? ToiletDetailBar(selectedToilet)
            : ToiletRecommendationList(toilets, selectToilet)
      ],
    );
  }
}
