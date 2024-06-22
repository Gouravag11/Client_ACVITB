// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyD7BkeG2J5klnq-1dtiNzgST9nf75sdFyY',
    appId: '1:764725352319:web:3baae26a7626e176cbec4a',
    messagingSenderId: '764725352319',
    projectId: 'android-club-82fd3',
    authDomain: 'android-club-82fd3.firebaseapp.com',
    storageBucket: 'android-club-82fd3.appspot.com',
    measurementId: 'G-D0D7B06K2C',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCr9gfly_WT29jr4-OvQMdZpT0X6JDMWD4',
    appId: '1:764725352319:android:2b7f0c01b80e1867cbec4a',
    messagingSenderId: '764725352319',
    projectId: 'android-club-82fd3',
    storageBucket: 'android-club-82fd3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAHIxtds9T8gLDqEPiFO8qoKGVY-CBmHEY',
    appId: '1:764725352319:ios:b5c3d51415254f45cbec4a',
    messagingSenderId: '764725352319',
    projectId: 'android-club-82fd3',
    storageBucket: 'android-club-82fd3.appspot.com',
    iosBundleId: 'com.example.androidClubApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAHIxtds9T8gLDqEPiFO8qoKGVY-CBmHEY',
    appId: '1:764725352319:ios:b5c3d51415254f45cbec4a',
    messagingSenderId: '764725352319',
    projectId: 'android-club-82fd3',
    storageBucket: 'android-club-82fd3.appspot.com',
    iosBundleId: 'com.example.androidClubApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD7BkeG2J5klnq-1dtiNzgST9nf75sdFyY',
    appId: '1:764725352319:web:658439f13b9635a3cbec4a',
    messagingSenderId: '764725352319',
    projectId: 'android-club-82fd3',
    authDomain: 'android-club-82fd3.firebaseapp.com',
    storageBucket: 'android-club-82fd3.appspot.com',
    measurementId: 'G-YYKXPY6C5Z',
  );
}
