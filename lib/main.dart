import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

import "package:flutter_i18n/flutter_i18n.dart";
import 'package:flutter_localizations/flutter_localizations.dart';

import 'ui/screens/Home.dart';
import 'ui/screens/AddToilet.dart';
import 'ui/screens/AddNote.dart';
import 'ui/screens/AboutUs.dart';

import './core/viewmodels/ToiletModel.dart';
import './core/common/variables.dart';
import './core/common/statusBarObserver.dart';

import './locator.dart';

Future main() async {
  final FlutterI18nDelegate flutterI18nDelegate = FlutterI18nDelegate(
    translationLoader: FileTranslationLoader(
      useCountryCode: false,
      fallbackFile: 'en',
      basePath: 'assets/locales',
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await flutterI18nDelegate.load(null);
  runApp(Application(flutterI18nDelegate));
}

class Application extends StatelessWidget {
  final FlutterI18nDelegate flutterI18nDelegate;
  final GlobalKey<HomeState> _homeKey = new GlobalKey<HomeState>();

  Application(this.flutterI18nDelegate);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Budipest",
      theme: ThemeData(
        primarySwatch: black,
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Muli',
              fontSizeFactor: 1.4,
            ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => Home(key: _homeKey),
        '/addToilet': (context) => AddToilet(_homeKey),
        '/addNote': (context) => AddNote(),
        '/about': (context) => AboutUs()
      },
      navigatorObservers: [
        StatusBarObserver(),
      ],
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        flutterI18nDelegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('en'), // English
        const Locale('hu'), // Hungarian
      ],
    );
  }
}
