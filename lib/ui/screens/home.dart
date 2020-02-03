import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';

import '../widgets/map.dart';
import '../widgets/sidebar.dart';
import '../widgets/bottomBar.dart';
import '../../core/viewmodels/ToiletModel.dart';
import '../../core/viewmodels/UserModel.dart';
import '../../core/models/toilet.dart';
import '../../locator.dart';

class Home extends StatefulWidget {
  const Home();

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Location _location = new Location();
  final UserModel userModel = locator<UserModel>();

  ValueNotifier<double> _notifier = ValueNotifier<double>(0);
  PanelController _pc = new PanelController();
  List<Toilet> _data;
  Toilet _selected;

  @override
  void initState() {
    userModel.authenticate();
    super.initState();
  }

  void onBottomBarDrag(double val) {
    _notifier.value = val;
    if (val < 0.2) {
      _pc.animatePanelToPosition(0.2);
    }
  }

  void selectToilet(Toilet toilet) {
    setState(() {
      _selected = toilet;
    });
    if (toilet == null) {
      _pc.animatePanelToPosition(0.2);
    }
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
                stream: toiletProvider.fetchDataAsStream(),
                builder: (context, dataSnapshot) {
                  if (dataSnapshot.hasData) {
                    // Convert raw toilet _data into mapped and classified Toilet objects
                    _data = dataSnapshot.data.documents
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
                          minHeight: 80,
                          maxHeight: MediaQuery.of(context).size.height,
                          panel: AnimatedBuilder(
                            animation: _notifier,
                            builder: (context, _) => BottomBar(
                              _data,
                              _notifier.value > 0.2 ? _notifier.value : 0,
                              _selected,
                              selectToilet,
                            ),
                          ),
                          onPanelSlide: onBottomBarDrag,
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
                                            fillColor: Colors.black,
                                            elevation: 5.0,
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 30.0,
                                            ),
                                            onPressed: () {
                                              selectToilet(null);
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
                      child: Text(
                          "hiba tortent es nem tudtuk leszedni az adatokat :(((("),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                });
          } else if (locationSnapshot.hasError) {
            return Center(
              child: Text("hiba tortent es nem tudjuk h hol vagy geci :////"),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
