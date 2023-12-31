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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD-GdLgLzVGqmp25tG8cul7q3DzRVFA5EA',
    appId: '1:203340254867:web:43bafcef0da3e2679cc766',
    messagingSenderId: '203340254867',
    projectId: 'bicycle-rental-system-c4471',
    authDomain: 'bicycle-rental-system-c4471.firebaseapp.com',
    storageBucket: 'bicycle-rental-system-c4471.appspot.com',
    measurementId: 'G-RF7TLNBQF8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAkqZt9Gej0YLBEPDeOUXIcrWCJ6RoPjtQ',
    appId: '1:203340254867:android:b7a03e555a4f3a089cc766',
    messagingSenderId: '203340254867',
    projectId: 'bicycle-rental-system-c4471',
    storageBucket: 'bicycle-rental-system-c4471.appspot.com',
  );
}
