import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../widgets/BottomBar.dart';
import '../widgets/ErrorProvider.dart';
import '../widgets/Map.dart';
import '../widgets/Sidebar.dart';
import '../../core/providers/ToiletModel.dart';
import "Error.dart";

class Home extends StatelessWidget {
  Home({GlobalKey key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<MapState> _mapKey = GlobalKey<MapState>();

  final ValueNotifier<double> _notifier = ValueNotifier<double>(0);
  final PanelController _pc = PanelController();

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

  @override
  Widget build(BuildContext context) {
    final _toiletProvider = Provider.of<ToiletModel>(context);
    final _selectedToilet = _toiletProvider.selectedToilet;
    final _screenHeight = MediaQuery.of(context).size.height;
    final _screenWidth = MediaQuery.of(context).size.width;
    final _hasSelected = _selectedToilet == null;
    final _bottomBarMinHeight =
        80 + _screenHeight * (_hasSelected ? 0.15 : 0.3);

    if (_toiletProvider.appError != null) {
      return Scaffold(
        body: Stack(
          children: [
            ErrorProvider(),
            Error(_toiletProvider.appError),
          ],
        ),
      );
    } else if (!_toiletProvider.loaded) {
      return Scaffold(
        body: Stack(
          children: [
            ErrorProvider(),
            Center(child: CircularProgressIndicator())
          ],
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: Sidebar(),
      body: Stack(
        children: <Widget>[
          ErrorProvider(),
          SlidingUpPanel(
            controller: _pc,
            panelSnapping: true,
            minHeight: _bottomBarMinHeight,
            maxHeight: _screenHeight,
            panelBuilder: (ScrollController sc) => AnimatedBuilder(
              animation: _notifier,
              builder: (context, _) => BottomBar(
                _notifier.value < 0.3 ? 0 : (1 / 0.7) * (_notifier.value - 0.3),
                sc,
              ),
            ),
            onPanelSlide: (double val) => onBottomBarDrag(val),
            body: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: _screenWidth,
                height: _screenHeight - _bottomBarMinHeight,
                child: MapWidget(key: _mapKey),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _notifier,
            builder: (context, _) => Positioned(
              right: 0,
              bottom: (_screenHeight *
                      (_notifier.value * (_hasSelected ? 0.85 : 0.7))) +
                  (_bottomBarMinHeight + 20),
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
                  _mapKey.currentState.animateToLocation(
                    _toiletProvider.location.latitude,
                    _toiletProvider.location.longitude,
                  );
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
                  builder: (context, _) => Hero(
                    tag: "materialCloseButton",
                    child: RawMaterialButton(
                      shape: CircleBorder(),
                      fillColor: _notifier.value > 0.99
                          ? Colors.white
                          : _hasSelected
                              ? Colors.white
                              : Colors.black,
                      elevation: 5.0,
                      child: Icon(
                        _notifier.value > 0.99
                            ? Icons.close
                            : _hasSelected
                                ? Icons.menu
                                : Icons.close,
                        color: _notifier.value > 0.99
                            ? Colors.black
                            : _hasSelected
                                ? Colors.black
                                : Colors.white,
                        size: 30.0,
                      ),
                      onPressed: () {
                        if (_selectedToilet != null) {
                          _toiletProvider.selectToilet(null);
                        } else {
                          if (_notifier.value > 0.99) {
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
          ),
        ],
      ),
    );
  }
}
