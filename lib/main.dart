import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/about.dart';
import 'common/variables.dart';

void main() => runApp(Application());

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budipest',
      theme: ThemeData(primarySwatch: black, fontFamily: 'Lexend Deca'),
      initialRoute: '/',
      routes: {'/': (context) => Home(), '/about': (context) => About()},
    );
  }
}
