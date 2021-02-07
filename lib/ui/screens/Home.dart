import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../widgets/BottomBar.dart';
import '../widgets/ErrorProvider.dart';
import '../widgets/Map.dart';
import '../widgets/Sidebar.dart';
import '../../core/providers/ToiletModel.dart';
import "Error.dart";

class Home extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<MapState> _mapKey = GlobalKey<MapState>();

  final ValueNotifier<double> _notifier = ValueNotifier<double>(0);
  final PanelController _pc = PanelController();

  ScrollController _panelScrollController;

  void onBottomBarDrag(double val) {
    _notifier.value = val;

    if (val < 0.4) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark,
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.light,
      );
    }
  }

  bool backHandler(bool physicalBack, bool hasSelected, BuildContext context) {
    if (hasSelected) {
      selectNullToilet(context);
      return false;
    } else {
      if (_notifier.value > 0.99) {
        _panelScrollController.animateTo(
          0,
          duration: Duration(milliseconds: 100),
          curve: Curves.easeInOut,
        );
        _pc.close();
        return false;
      } else {
        if (!physicalBack) {
          _scaffoldKey.currentState.openDrawer();
          return false;
        } else {
          return true;
        }
      }
    }
  }

  void animateMapToUserLocation(BuildContext context) async {
    final Position location =
        Provider.of<ToiletModel>(context, listen: false).location;

    await _mapKey.currentState.animateToLocation(
      location.latitude,
      location.longitude,
    );

    _mapKey.currentState.updateMarkers(15.0);
  }

  void selectNullToilet(BuildContext context) {
    Provider.of<ToiletModel>(context, listen: false).selectToilet(null);
  }

  @override
  Widget build(BuildContext context) {
    final selectedToilet = context.select((ToiletModel m) => m.selectedToilet);
    final appError = context.select((ToiletModel m) => m.appError);
    final loaded = context.select((ToiletModel m) => m.loaded);
    final hasLocationPermission =
        context.select((ToiletModel m) => m.hasLocationPermission);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final hasSelected = selectedToilet != null;

    if (_pc.isAttached && _pc.panelPosition < 0.95) {
      if (hasSelected && _pc.panelPosition != 0.175) {
        _pc.animatePanelToPosition(
          0.175,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      } else if (!hasSelected && _pc.panelPosition != 0) {
        _pc.animatePanelToPosition(
          0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      }
    }

    if (appError != null) {
      return Scaffold(
        body: Stack(
          children: [
            ErrorProvider(),
            Error(appError),
          ],
        ),
      );
    } else if (!loaded) {
      return Scaffold(
        body: Stack(
          children: [
            ErrorProvider(),
            Center(child: CircularProgressIndicator())
          ],
        ),
      );
    }

    final bottomBarMinHeight = 80 + screenHeight * 0.15;

    return WillPopScope(
      onWillPop: () async {
        return backHandler(true, hasSelected, context);
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const Sidebar(),
        body: Stack(
          children: <Widget>[
            ErrorProvider(),
            SlidingUpPanel(
              controller: _pc,
              panelSnapping: true,
              minHeight: bottomBarMinHeight,
              maxHeight: screenHeight,
              snapPoint: hasSelected ? 0.175 : null,
              panelBuilder: (ScrollController sc) {
                _panelScrollController = sc;

                return AnimatedBuilder(
                  animation: _notifier,
                  builder: (context, _) => BottomBar(
                    _notifier.value < 0.3
                        ? 0
                        : (1 / 0.7) * (_notifier.value - 0.3),
                    sc,
                  ),
                );
              },
              onPanelSlide: (double val) => onBottomBarDrag(val),
              body: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: screenWidth,
                  height: screenHeight - bottomBarMinHeight,
                  child: MapWidget(key: _mapKey),
                ),
              ),
            ),
            hasLocationPermission
                ? AnimatedBuilder(
                    animation: _notifier,
                    builder: (_, child) => Positioned(
                      right: 0,
                      bottom: (screenHeight * _notifier.value) +
                          (bottomBarMinHeight + 20),
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
                        onPressed: () => animateMapToUserLocation(context),
                      ),
                    ),
                  )
                : Container(),
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
                    builder: (context, _) => Hero(
                      tag: "materialCloseButton",
                      child: RawMaterialButton(
                        shape: CircleBorder(),
                        fillColor: _notifier.value > 0.99
                            ? Colors.white
                            : hasSelected
                                ? Colors.black
                                : Colors.white,
                        elevation: 5.0,
                        child: Icon(
                          _notifier.value > 0.99
                              ? Icons.close
                              : hasSelected
                                  ? Icons.close
                                  : Icons.menu,
                          color: _notifier.value > 0.99
                              ? Colors.black
                              : hasSelected
                                  ? Colors.white
                                  : Colors.black,
                          size: 30.0,
                        ),
                        onPressed: () => backHandler(
                          false,
                          hasSelected,
                          context,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
