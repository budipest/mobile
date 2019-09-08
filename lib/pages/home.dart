import 'package:Budipest/components/header.dart';
import 'package:flutter/material.dart';
import '../components/map.dart';
import '../components/sidebar.dart';

class Home extends StatelessWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      body: Center(
          child: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Map(),
            ],
          ),
          Header(),
        ],
      )),
    );
  }
}
