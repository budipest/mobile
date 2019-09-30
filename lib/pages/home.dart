import 'package:flutter/material.dart';
// import '../components/header.dart';
import '../components/map.dart';
import '../components/sidebar.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      body: Center(
          child: Stack(
        children: <Widget>[
          MapWidget(),
        ],
      )),
    );
  }
}
