import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../widgets/Map.dart';
import '../widgets/Sidebar.dart';
import '../widgets/BottomBar.dart';
import '../../core/models/Toilet.dart';
import '../../core/providers/ToiletModel.dart';

class Home extends StatelessWidget {
  Home({GlobalKey key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<MapState> _mapKey = new GlobalKey<MapState>();

  final ValueNotifier<double> _notifier = ValueNotifier<double>(0);
  final PanelController _pc = new PanelController();

  void onBottomBarDrag(double val, bool hasSelected) {
    _notifier.value = val;

    if (val < 0.4) {
      if (!_pc.isPanelAnimating && hasSelected && val < 0.2) {
        _pc.animatePanelToPosition(
          0.15,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      } else if (!_pc.isPanelAnimating && !hasSelected && val < 0.4) {
        _pc.animatePanelToPosition(
          0.3,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
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

  void animateForSelection(Toilet selectedToilet) {
    if (selectedToilet == null) {
      if (_notifier.value < 0.5)
        _pc.animatePanelToPosition(
          0.15,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
    } else {
      _mapKey.currentState.animateToLocation(
        selectedToilet.latitude,
        selectedToilet.longitude,
      );
      if (_notifier.value < 0.5)
        _pc.animatePanelToPosition(
          0.3,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _toiletProvider = Provider.of<ToiletModel>(context);
    final _selectedToilet = _toiletProvider.selectedToilet;

    if (_toiletProvider.loaded) {
      if (_pc.isAttached) {
        animateForSelection(_selectedToilet);
      }

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
                  _notifier.value < 0.3
                      ? 0
                      : (1 / 0.7) * (_notifier.value - 0.3),
                  sc,
                ),
              ),
              onPanelSlide: (double val) =>
                  onBottomBarDrag(val, _selectedToilet == null),
              body: MapWidget(
                onMapCreated: () => _pc.animatePanelToPosition(
                  0.15,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                ),
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
                            : _selectedToilet != null
                                ? Colors.black
                                : Colors.white,
                        elevation: 5.0,
                        child: Icon(
                          _notifier.value > 0.99
                              ? Icons.close
                              : _selectedToilet != null
                                  ? Icons.close
                                  : Icons.menu,
                          color: _notifier.value > 0.99
                              ? Colors.black
                              : _selectedToilet != null
                                  ? Colors.white
                                  : Colors.black,
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
    } else {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      );
    }
  }
}
