import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';

import '../widgets/map.dart';
import '../widgets/sidebar.dart';
import '../widgets/toiletsNearbyBar.dart';
import '../../core/viewmodels/ToiletModel.dart';
import '../../core/models/toilet.dart';

class Home extends StatefulWidget {
  const Home();

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Location _location = new Location();

  Animation<double> animation;
  AnimationController controller;
  List<Toilet> data;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final toiletProvider = Provider.of<ToiletModel>(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: Sidebar(),
      body: FutureBuilder(
        future: _location.getLocation(),
        builder: (context, locationSnapshot) {
          if (locationSnapshot.hasData) {
            return StreamBuilder(
                stream: toiletProvider.fetchQueriedData(
                  50,
                  locationSnapshot.data["latitude"],
                  locationSnapshot.data["longitude"],
                ),
                builder: (context, dataSnapshot) {
                  print(locationSnapshot.data["latitude"]);
                  print(locationSnapshot.data["longitude"]);
                  if (dataSnapshot.hasData) {
                    print(dataSnapshot.data);
                    // Convert raw toilet data into mapped and classified Toilet objects
                    data = dataSnapshot.data
                        .map((doc) => Toilet.fromMap(doc.data, doc.documentID))
                        .toList()
                        .cast<Toilet>();

                    // Initialise distance property on every toilet
                    data.forEach((toilet) {
                      toilet.calculateDistance(locationSnapshot.data);
                    });

                    // Sort toilets based on their distance from the user
                    data.sort((a, b) => a.distance.compareTo(b.distance));

                    return SlidingUpPanel(
                      panelSnapping: true,
                      minHeight: 200,
                      maxHeight: MediaQuery.of(context).size.height,
                      panel: ToiletsNearbyBar(data),
                      body: Center(
                        child: Center(
                          child: Stack(
                            children: <Widget>[
                              MapWidget(data, locationSnapshot.data),
                              SafeArea(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 12.0),
                                  child: FloatingActionButton(
                                    child: Icon(
                                      Icons.menu,
                                      color: Colors.black,
                                    ),
                                    mini: true,
                                    onPressed: () =>
                                        _scaffoldKey.currentState.openDrawer(),
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else if (dataSnapshot.hasError) {
                    return Center(
                        child: Text("haha el succoltak az adatok :):(:):("));
                  } else {
                    return Center(child: Text("töltjük le z adatokat, chill <33333333"));
                  }
                });
          } else if (locationSnapshot.hasError) {
            return Center(child: Text("ok szóval nem tudjuk honnan vagy geci :////"));
          } else {
            return Center(child: Text("na, még keresünk téged, chill <<<3333"));
          }
        },
      ),
    );
  }
}
