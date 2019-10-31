import 'package:flutter/material.dart';

import '../../core/models/toilet.dart';
import '../../core/common/determineIcon.dart';

import './toiletCard.dart';

class ToiletsNearbyBar extends StatelessWidget {
  ToiletsNearbyBar(this.toilets);
  final List<Toilet> toilets;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          color: Colors.black,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                    height: 4,
                    width: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(40.0))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 15.0, 0, 7.5),
                  child: Text(
                    "Ajánlott mosdó:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    ...describeToiletIcons(toilets[0], "light"),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          toilets[0].title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${toilets[0].distance} m",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16.0,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0.0),
          child: Text(
            "További mosdók",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: toilets.length,
            padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 25.0),
            itemBuilder: (BuildContext ctxt, int index) => GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                print("${toilets[index].title} got tapped!");
              },
              child: ToiletCard(toilets[index]),
            ),
          ),
        ),
      ],
    );
  }
}
