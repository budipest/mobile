import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

import './ui/screens/home.dart';
import './ui/screens/addToilet.dart';

import './core/viewmodels/ToiletModel.dart';
import './core/common/variables.dart';

import './locator.dart';

void main() {
  setupLocator();
  runApp(Application());
}

class Application extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context) => locator<ToiletModel>())
      ],
      child: MaterialApp(
        title: 'Budipest',
        theme: ThemeData(
          primarySwatch: black,
          textTheme: Theme.of(context).textTheme.apply(
                fontFamily: 'Muli',
                fontSizeFactor: 1.4,
              ),
        ),
        initialRoute: '/',
        routes: {'/': (context) => Home(), '/add': (context) => AddToilet()},
        // routes: {'/': (context) => AddToilet()},
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
      ),
    );
  }
}
