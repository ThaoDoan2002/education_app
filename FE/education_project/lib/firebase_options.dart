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
    apiKey: 'AIzaSyDgPOFm1EM5J0MLw2iuXcKOGpg5r3D2sDc',
    appId: '1:715527768351:web:753a50ba301f5880ff482a',
    messagingSenderId: '715527768351',
    projectId: 'fire-setup-8f873',
    authDomain: 'fire-setup-8f873.firebaseapp.com',
    storageBucket: 'fire-setup-8f873.firebasestorage.app',
    measurementId: 'G-EPYM3V06ZH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC-cbQLVI5dXsfxGCEdRvBhiV6aAY2ov3E',
    appId: '1:715527768351:android:ef02785abb2c1d05ff482a',
    messagingSenderId: '715527768351',
    projectId: 'fire-setup-8f873',
    storageBucket: 'fire-setup-8f873.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBp71jjWbU-GRmxiFpjYREhQ4bQg95bDKE',
    appId: '1:715527768351:ios:901bc680cd1d678dff482a',
    messagingSenderId: '715527768351',
    projectId: 'fire-setup-8f873',
    storageBucket: 'fire-setup-8f873.firebasestorage.app',
    iosBundleId: 'com.dtt.educationProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBp71jjWbU-GRmxiFpjYREhQ4bQg95bDKE',
    appId: '1:715527768351:ios:901bc680cd1d678dff482a',
    messagingSenderId: '715527768351',
    projectId: 'fire-setup-8f873',
    storageBucket: 'fire-setup-8f873.firebasestorage.app',
    iosBundleId: 'com.dtt.educationProject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDgPOFm1EM5J0MLw2iuXcKOGpg5r3D2sDc',
    appId: '1:715527768351:web:82d699c4c1bc1c36ff482a',
    messagingSenderId: '715527768351',
    projectId: 'fire-setup-8f873',
    authDomain: 'fire-setup-8f873.firebaseapp.com',
    storageBucket: 'fire-setup-8f873.firebasestorage.app',
    measurementId: 'G-9X3J66T15K',
  );
}
