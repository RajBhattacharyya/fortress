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
    apiKey: 'AIzaSyD3pEUg5n5CLWoLFeMIIFKLdpUN_VzHTiw',
    appId: '1:23565840481:web:532544ba1bc4573ba9ba20',
    messagingSenderId: '23565840481',
    projectId: 'safesync-ef8da',
    authDomain: 'safesync-ef8da.firebaseapp.com',
    databaseURL: 'https://safesync-ef8da-default-rtdb.firebaseio.com',
    storageBucket: 'safesync-ef8da.appspot.com',
    measurementId: 'G-XPPFTTQ4PV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA99OsKZvoEt8uvnjw5INLGdtGgQhyDK9U',
    appId: '1:23565840481:android:601fa26aa9914c2da9ba20',
    messagingSenderId: '23565840481',
    projectId: 'safesync-ef8da',
    databaseURL: 'https://safesync-ef8da-default-rtdb.firebaseio.com',
    storageBucket: 'safesync-ef8da.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCnJmPgQni6TQ0Doa8Zbl69_DZl1M_U67Y',
    appId: '1:23565840481:ios:7294001059123915a9ba20',
    messagingSenderId: '23565840481',
    projectId: 'safesync-ef8da',
    databaseURL: 'https://safesync-ef8da-default-rtdb.firebaseio.com',
    storageBucket: 'safesync-ef8da.appspot.com',
    androidClientId: '23565840481-mv201ba84ef3mevruefuovas2qniv21c.apps.googleusercontent.com',
    iosBundleId: 'com.example.fortress',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCnJmPgQni6TQ0Doa8Zbl69_DZl1M_U67Y',
    appId: '1:23565840481:ios:7294001059123915a9ba20',
    messagingSenderId: '23565840481',
    projectId: 'safesync-ef8da',
    databaseURL: 'https://safesync-ef8da-default-rtdb.firebaseio.com',
    storageBucket: 'safesync-ef8da.appspot.com',
    androidClientId: '23565840481-mv201ba84ef3mevruefuovas2qniv21c.apps.googleusercontent.com',
    iosBundleId: 'com.example.fortress',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD3pEUg5n5CLWoLFeMIIFKLdpUN_VzHTiw',
    appId: '1:23565840481:web:e71f6e4b5852fbaea9ba20',
    messagingSenderId: '23565840481',
    projectId: 'safesync-ef8da',
    authDomain: 'safesync-ef8da.firebaseapp.com',
    databaseURL: 'https://safesync-ef8da-default-rtdb.firebaseio.com',
    storageBucket: 'safesync-ef8da.appspot.com',
    measurementId: 'G-R0PYW8GDNM',
  );
}
