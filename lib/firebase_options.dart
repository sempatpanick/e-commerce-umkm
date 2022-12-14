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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBpdKLG7oVNq5PaEyerHUCOs1vVHGa--Jo',
    appId: '1:350330971043:web:f8e13d05b59d79edbf3016',
    messagingSenderId: '350330971043',
    projectId: 'pacific-arcadia-350102',
    authDomain: 'pacific-arcadia-350102.firebaseapp.com',
    storageBucket: 'pacific-arcadia-350102.appspot.com',
    measurementId: 'G-THFHV5PYEY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDfbcpSBfa9cPl_9eDKSRaVB3Pl53O3_ng',
    appId: '1:350330971043:android:cecc73c2f59da5fcbf3016',
    messagingSenderId: '350330971043',
    projectId: 'pacific-arcadia-350102',
    storageBucket: 'pacific-arcadia-350102.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA0FpAEgyBZ-cZA4smu_DcmT6u9hK9KQho',
    appId: '1:350330971043:ios:06e0bfe80eafd889bf3016',
    messagingSenderId: '350330971043',
    projectId: 'pacific-arcadia-350102',
    storageBucket: 'pacific-arcadia-350102.appspot.com',
    iosClientId: '350330971043-mn69piaivdqp3sip4ad19o9j9nqcci18.apps.googleusercontent.com',
    iosBundleId: 'com.sempatpanick.eWarung',
  );
}
