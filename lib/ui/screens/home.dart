import 'package:flutter/material.dart';

import '../widgets/map.dart';
import '../widgets/sidebar.dart';

class Home extends StatefulWidget {
  const Home();

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Sidebar(),
      body: Center(
          child: Stack(
        children: <Widget>[
          MapWidget(),
          SafeArea(
              child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
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
      )),
    );
  }
}
