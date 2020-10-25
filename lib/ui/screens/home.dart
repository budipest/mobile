import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
// import 'package:provider/provider.dart';
import 'package:location/location.dart';

import 'Error.dart';
import '../widgets/Map.dart';
import '../widgets/Sidebar.dart';
import '../widgets/BottomBar.dart';
import '../../core/viewmodels/ToiletModel.dart';
import '../../core/common/openHourUtils.dart';
import '../../core/models/Toilet.dart';
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

  ValueNotifier<double> _notifier = ValueNotifier<double>(0);
  PanelController _pc = new PanelController();
  LocationData locationData;
  List<Toilet> _data;
  Toilet _recommendedToilet;
  Toilet _selected;

  @override
  void initState() {
    _location.onLocationChanged.listen((event) {
      updateData(event);
    });

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
        toilet.latitude,
        toilet.longitude,
      );
      if (_notifier.value < 0.5) _pc.animatePanelToPosition(0.3);
    }
  }

  void updateData(LocationData location) async {
    // TODO: implement pulling toilets

    // final _newToilets =
    //     await Provider.of<ToiletModel>(context).getToilets(location);

    setState(() {
      // _data = _newToilets;
      locationData = location;
      _recommendedToilet = _data.firstWhere(
        (Toilet toilet) => isOpen(toilet.openHours),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // final toiletProvider = Provider.of<ToiletModel>(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: Sidebar(),
      body: Stack(
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
                _recommendedToilet,
                sc,
              ),
            ),
            onPanelSlide: onBottomBarDrag,
            body: MapWidget(
              _data,
              locationData,
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
              bottom: ((MediaQuery.of(context).size.height - 80) *
                      _notifier.value) +
                  95,
              child: RawMaterialButton(
                shape: CircleBorder(),
                fillColor: Colors.white,
                elevation: 12.5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.my_location,
                    color: Colors.grey[800],
                    size: 27.5,
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
      ),
    );
  }
}
