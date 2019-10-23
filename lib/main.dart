import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'screens/home.dart';
import 'screens/about.dart';
import 'common/variables.dart';

void main() => runApp(Application());

class Application extends StatelessWidget {
  FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budipest',
      theme: ThemeData(
          primarySwatch: black,
          textTheme: Theme.of(context)
              .textTheme
              .apply(fontFamily: 'Muli', fontSizeFactor: 1.4)),
      initialRoute: '/',
      routes: {'/': (context) => Home(), '/about': (context) => About()},
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
    );
  }
}
