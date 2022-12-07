// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDqbuneva9i_tLJu5xCu-ni9wHFBqToW7A',
    appId: '1:721098962234:android:d401da42f75bfa99d60c03',
    messagingSenderId: '721098962234',
    projectId: 'dantech-solutions',
    databaseURL: 'https://dantech-solutions-default-rtdb.firebaseio.com',
    storageBucket: 'dantech-solutions.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD7WRJlv_1vQpT1mT-5LMxbL4vK8NmVOj8',
    appId: '1:721098962234:ios:0dbb60db82380027d60c03',
    messagingSenderId: '721098962234',
    projectId: 'dantech-solutions',
    databaseURL: 'https://dantech-solutions-default-rtdb.firebaseio.com',
    storageBucket: 'dantech-solutions.appspot.com',
    androidClientId: '721098962234-24kn8ucepcgd9hjn251u4mkn6e2u2jma.apps.googleusercontent.com',
    iosClientId: '721098962234-874imbtb6t4bg1oj5siebc4063m93gi9.apps.googleusercontent.com',
    iosBundleId: 'com.dantech.kenyaflix',
  );
}