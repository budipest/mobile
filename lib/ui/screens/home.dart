import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../widgets/map.dart';
import '../widgets/sidebar.dart';
import '../widgets/bottomBar.dart';

class Home extends StatefulWidget {
  const Home();

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Sidebar(),
      body: SlidingUpPanel(
        parallaxEnabled: true,
        parallaxOffset: 0.5,
        minHeight: 200,
        maxHeight: MediaQuery.of(context).size.height,
        panel: BottomBar(),
        body: Center(
          child: Center(
            child: Stack(
              children: <Widget>[
                MapWidget(),
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
                      onPressed: () => _scaffoldKey.currentState.openDrawer(),
                      backgroundColor: Colors.white),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
