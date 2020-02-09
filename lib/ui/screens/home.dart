import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';

import './error.dart';
import '../widgets/map.dart';
import '../widgets/sidebar.dart';
import '../widgets/bottomBar.dart';
import '../../core/viewmodels/ToiletModel.dart';
import '../../core/viewmodels/UserModel.dart';
import '../../core/common/openHourUtils.dart';
import '../../core/models/toilet.dart';
import '../../locator.dart';

class Home extends StatefulWidget {
  const Home({GlobalKey key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<MapState> _mapKey = new GlobalKey<MapState>();
  final Location _location = new Location();
  final UserModel userModel = locator<UserModel>();

  ValueNotifier<double> _notifier = ValueNotifier<double>(0);
  Map<String, double> location;
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

    if (val < 0.8) {
      if (_selected == null) {
        if (val < 0.15) {
          _pc.animatePanelToPosition(0.15);
        }
      } else {
        if (val < 0.3) {
          _pc.animatePanelToPosition(0.3);
        }
      }
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
    if (toilet == null) {
      if (_notifier.value < 0.5) _pc.animatePanelToPosition(0.15);
    } else {
      _mapKey.currentState.animateToLocation(
        toilet.geopoint.latitude,
        toilet.geopoint.longitude,
      );
      if (_notifier.value < 0.5) _pc.animatePanelToPosition(0.3);
    }
  }

  @override
  Widget build(BuildContext context) {
    final toiletProvider = Provider.of<ToiletModel>(context);
    return Scaffold(
      key: _scaffoldKey,
      drawer: Sidebar(),
      body: StreamBuilder(
        stream: _location.onLocationChanged(),
        builder: (context, locationSnapshot) {
          print("locationSnapshot.data");
          print(locationSnapshot.data);
          if (locationSnapshot.hasData) {
            location = locationSnapshot.data;

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
                    toilet.calculateDistance(location);
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
                        panelBuilder: (ScrollController sc) => AnimatedBuilder(
                          animation: _notifier,
                          builder: (context, _) => BottomBar(
                            _data,
                            _notifier.value > 0.3 ? _notifier.value : 0,
                            _selected,
                            selectToilet,
                            recommendedToilet,
                            sc,
                          ),
                        ),
                        onPanelSlide: onBottomBarDrag,
                        body: MapWidget(
                          _data,
                          location,
                          selectToilet,
                          onMapCreated: () {
                            _pc.animatePanelToPosition(0.15);
                          },
                          key: _mapKey,
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _notifier,
                        builder: (context, _) => Positioned(
                          right: 0,
                          bottom: (_notifier.value + 0.125) *
                              ((MediaQuery.of(context).size.height)),
                          child: RawMaterialButton(
                            shape: CircleBorder(),
                            fillColor: Colors.white,
                            elevation: 5.0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.my_location,
                                color: Colors.black,
                                size: 25.0,
                              ),
                            ),
                            onPressed: () {
                              _mapKey.currentState.animateToUser();
                            },
                          ),
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
                                      _scaffoldKey.currentState.openDrawer();
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (dataSnapshot.hasError) {
                  return Error(FlutterI18n.translate(context, "error.data"));
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            );
          } else if (locationSnapshot.hasError) {
            return Error(FlutterI18n.translate(context, "error.location"));
          } else {
            _location.getLocation(); // sometimes the location package needs a manual kick to get working with the stream.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
