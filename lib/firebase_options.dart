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
      return web;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCRArzMzJaJicnY_hdg963Z38LA6JSVs9I',
    appId: '1:1041809532425:web:76d63925d55be19ffc7ad8',
    messagingSenderId: '1041809532425',
    projectId: 'ecommerce-app-e20e4',
    authDomain: 'ecommerce-app-e20e4.firebaseapp.com',
    databaseURL: 'https://ecommerce-app-e20e4-default-rtdb.firebaseio.com',
    storageBucket: 'ecommerce-app-e20e4.appspot.com',
    measurementId: 'G-815PDPFX8T',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAb3Ri2mvfH827YUh2A5JO5lF-tvWSq46k',
    appId: '1:1041809532425:android:85d599cfb4af90fafc7ad8',
    messagingSenderId: '1041809532425',
    projectId: 'ecommerce-app-e20e4',
    databaseURL: 'https://ecommerce-app-e20e4-default-rtdb.firebaseio.com',
    storageBucket: 'ecommerce-app-e20e4.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC7vPg7NnYSama406lEOLJnOG527FzoWfI',
    appId: '1:1041809532425:ios:8ffa22a3b7936cd2fc7ad8',
    messagingSenderId: '1041809532425',
    projectId: 'ecommerce-app-e20e4',
    databaseURL: 'https://ecommerce-app-e20e4-default-rtdb.firebaseio.com',
    storageBucket: 'ecommerce-app-e20e4.appspot.com',
    androidClientId: '1041809532425-ekj2q7ihts1if9c7g1g3n0tit3l9rqr6.apps.googleusercontent.com',
    iosClientId: '1041809532425-vnkfhmhmjqdmr42ipkvthkk12ifpvp13.apps.googleusercontent.com',
    iosBundleId: 'arpan.delivery',
  );
}
