// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBVVqXnw26K3dwQyTnakbN5IzjYQXnvvnU',
    appId: '1:251201033430:android:832fe25f2beec52257a577',
    messagingSenderId: '251201033430',
    projectId: 'budipest-298513',
    storageBucket: 'budipest-298513.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCm8eEYm5TL09uQ-4qZIyy-iEvGyYcLDZE',
    appId: '1:251201033430:ios:505522a1bc1b83c457a577',
    messagingSenderId: '251201033430',
    projectId: 'budipest-298513',
    storageBucket: 'budipest-298513.appspot.com',
    iosClientId: '251201033430-5hjnc7ssj4pu6tsa66bbsajd4dh4ii7k.apps.googleusercontent.com',
    iosBundleId: 'hu.dnlgrgly.budipest',
  );
}
