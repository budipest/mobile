import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../../core/models/toilet.dart';
import '../../core/common/determineIcon.dart';

class BottomBar extends StatelessWidget {
  BottomBar(this.toilets);
  final Location _location = new Location();
  List<Toilet> toilets;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _location.getLocation(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          toilets.forEach((toilet) {
            toilet.calculateDistance(snapshot.data);
          });

          toilets.sort((a, b) => a.distance.compareTo(b.distance));

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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0))),
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
                                "${toilets[0].distance * 1000} m",
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
                  itemBuilder: (BuildContext ctxt, int index) {
                    return new Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      margin: EdgeInsets.symmetric(vertical: 7.5),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 25.0, vertical: 15.0),
                        child: Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  toilets[index].title,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${toilets[index].distance * 1000} m",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return Text(
              "Még nem adtál jogosultságot a helyzetedhez. Vagy csak bénák vagyunk. Várj egy picit :)");
        }
      },
    );
  }
}
