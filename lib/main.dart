import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'ui/screens/Home.dart';
import 'ui/screens/AddToilet.dart';
import 'ui/screens/AddNote.dart';
import 'ui/screens/AboutUs.dart';

import 'core/common/variables.dart';
import 'core/common/statusBarObserver.dart';
import 'core/providers/ToiletModel.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    ChangeNotifierProvider(
      create: (context) => ToiletModel(),
      child: Application(),
    ),
  );
}

class Application extends StatelessWidget {
  Application();

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
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child,
        );
      },
      routes: {
        '/': (context) => Home(),
        '/addToilet': (context) => AddToilet(),
        '/addNote': (context) => AddNote(),
        '/about': (context) => AboutUs()
      },
      navigatorObservers: [
        StatusBarObserver(),
      ],
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
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
