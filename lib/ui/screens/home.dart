import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../widgets/map.dart';
import '../widgets/sidebar.dart';
import '../widgets/bottomBar.dart';
import '../../core/viewmodels/ToiletModel.dart';
import '../../core/viewmodels/UserModel.dart';
import '../../core/common/openHourUtils.dart';
import '../../core/models/toilet.dart';
import '../../locator.dart';

class Home extends StatefulWidget {
  const Home();

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<MapState> _mapKey = new GlobalKey<MapState>();
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

    if (val < 0.8) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark,
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.light,
      );
    }
  }

  void selectToilet(Toilet toilet) {
    setState(() {
      _selected = toilet;
    });
  }

  @override
  Widget build(BuildContext context) {
    // _mapKey.currentState.animateToUser();

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

                    Toilet recommendedToilet = _data.firstWhere(
                      (Toilet toilet) => isOpen(toilet.openHours),
                    );

                    return Stack(
                      children: <Widget>[
                        SlidingUpPanel(
                          controller: _pc,
                          panelSnapping: true,
                          minHeight: 80,
                          maxHeight: MediaQuery.of(context).size.height,
                          panelBuilder: (ScrollController sc) =>
                              AnimatedBuilder(
                            animation: _notifier,
                            builder: (context, _) => BottomBar(
                                _data,
                                _notifier.value > 0.2 ? _notifier.value : 0,
                                _selected,
                                selectToilet,
                                recommendedToilet,
                                sc),
                          ),
                          onPanelSlide: onBottomBarDrag,
                          body: MapWidget(
                            _data,
                            locationSnapshot.data,
                            selectToilet,
                            onMapCreated: () {
                              setState(() {
                                _pc.animatePanelToPosition(0.2);
                              });
                            },
                            key: _mapKey,
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
                                  builder: (context, _) => RawMaterialButton(
                                        shape: CircleBorder(),
                                        fillColor: _notifier.value == 1
                                            ? Colors.white
                                            : _selected != null
                                                ? Colors.black
                                                : Colors.white,
                                        elevation: 5.0,
                                        child: Icon(
                                          _notifier.value == 1
                                              ? Icons.close
                                              : _selected != null
                                                  ? Icons.close
                                                  : Icons.menu,
                                          color: _notifier.value == 1
                                              ? Colors.black
                                              : _selected != null
                                                  ? Colors.white
                                                  : Colors.black,
                                          size: 30.0,
                                        ),
                                        onPressed: () {
                                          if (_selected != null) {
                                            selectToilet(null);
                                          } else {
                                            if (_notifier.value == 1) {
                                              _pc.close();
                                            } else {
                                              _scaffoldKey.currentState
                                                  .openDrawer();
                                            }
                                          }
                                        },
                                      )),
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
