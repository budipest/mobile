import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';

import '../widgets/map.dart';
import '../widgets/sidebar.dart';
import '../widgets/bottomBar.dart';
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

  ValueNotifier<double> _notifier = ValueNotifier<double>(0);
  PanelController _pc = new PanelController();
  // Animation<double> _animation;
  AnimationController _controller;
  List<Toilet> _data;
  Toilet _selected;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      lowerBound: 200.0,
      upperBound: 275.0,
    );

    // _animation = Tween<double>(begin: 200, end: 275).animate(_controller)
    //   ..addListener(() {
    //     setState(() {});
    //   });

    _controller.forward();
  }

  void selectToilet(Toilet toilet) {
    setState(() {
      _selected = toilet;
    });
    if (toilet != null) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                  5,
                  locationSnapshot.data["latitude"],
                  locationSnapshot.data["longitude"],
                ),
                builder: (context, dataSnapshot) {
                  if (dataSnapshot.hasData) {
                    // Convert raw toilet _data into mapped and classified Toilet objects
                    _data = dataSnapshot.data
                        .map((doc) => Toilet.fromMap(doc.data, doc.documentID))
                        .toList()
                        .cast<Toilet>();

                    // Initialise distance property on every toilet
                    _data.forEach((toilet) {
                      toilet.calculateDistance(locationSnapshot.data);
                    });

                    // Sort toilets based on their distance from the user
                    _data.sort((a, b) => a.distance.compareTo(b.distance));

                    return Stack(
                      children: <Widget>[
                        SlidingUpPanel(
                          controller: _pc,
                          panelSnapping: true,
                          minHeight: _controller.value,
                          maxHeight: MediaQuery.of(context).size.height,
                          panel: AnimatedBuilder(
                            animation: _notifier,
                            builder: (context, _) => BottomBar(
                              _data,
                              _notifier.value,
                              _selected,
                              selectToilet,
                            ),
                          ),
                          onPanelSlide: (double val) => _notifier.value = val,
                          body: MapWidget(
                            _data,
                            locationSnapshot.data,
                            selectToilet,
                          ),
                        ),
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                              vertical: 20.0,
                            ),
                            child: Container(
                              width: 50.0,
                              height: 50.0,
                              child: AnimatedBuilder(
                                animation: _notifier,
                                builder: (context, _) => _notifier.value == 1
                                    ? RawMaterialButton(
                                        shape: CircleBorder(),
                                        fillColor: Colors.white,
                                        elevation: 5.0,
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.black,
                                          size: 30.0,
                                        ),
                                        onPressed: () => _pc.close(),
                                      )
                                    : _selected != null
                                        ? RawMaterialButton(
                                            shape: CircleBorder(),
                                            fillColor: Colors.white,
                                            elevation: 5.0,
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.black,
                                              size: 30.0,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _selected = null;
                                              });
                                            },
                                          )
                                        : RawMaterialButton(
                                            shape: CircleBorder(),
                                            fillColor: Colors.white,
                                            elevation: 5.0,
                                            child: Icon(
                                              Icons.menu,
                                              color: Colors.black,
                                            ),
                                            onPressed: () => _scaffoldKey
                                                .currentState
                                                .openDrawer(),
                                          ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (dataSnapshot.hasError) {
                    return Center(
                      child: Text("haha el succoltak az adatok :):(:):("),
                    );
                  } else {
                    return Center(
                      child: Text("töltjük le z adatokat, chill <33333333"),
                    );
                  }
                });
          } else if (locationSnapshot.hasError) {
            return Center(
              child: Text("ok szóval nem tudjuk honnan vagy geci :////"),
            );
          } else {
            return Center(
              child: Text("na, még keresünk téged, chill <<<3333"),
            );
          }
        },
      ),
    );
  }
}
