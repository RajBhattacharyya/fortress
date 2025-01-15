import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
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
    apiKey: 'AIzaSyBiPFQodTtHxZW63EWEsNz76UcpzQ4Ohv0',
    appId: '1:668706618778:web:96e9237efbc7460ab84e23',
    messagingSenderId: '668706618778',
    projectId: 'to-do-55772',
    authDomain: 'to-do-55772.firebaseapp.com',
    databaseURL: 'https://to-do-55772-default-rtdb.firebaseio.com',
    storageBucket: 'to-do-55772.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA4_-Wm5caZz3iSDfKtp25hQ8MHpenWT4I',
    appId: '1:668706618778:android:67fcb0b6369ca3f8b84e23',
    messagingSenderId: '668706618778',
    projectId: 'to-do-55772',
    databaseURL: 'https://to-do-55772-default-rtdb.firebaseio.com',
    storageBucket: 'to-do-55772.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyASmJ4uT7IjTdemvExBghm7-01Rph-Bnh4',
    appId: '1:668706618778:ios:d0d31576f05ab82eb84e23',
    messagingSenderId: '668706618778',
    projectId: 'to-do-55772',
    databaseURL: 'https://to-do-55772-default-rtdb.firebaseio.com',
    storageBucket: 'to-do-55772.appspot.com',
    androidClientId: '668706618778-k36ak01k6oa6oqmcu4rjn29f847mu8ot.apps.googleusercontent.com',
    iosClientId: '668706618778-omlq44ld1uqk9nuete4vcq4m7b4jn346.apps.googleusercontent.com',
    iosBundleId: 'com.example.fortress',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyASmJ4uT7IjTdemvExBghm7-01Rph-Bnh4',
    appId: '1:668706618778:ios:d0d31576f05ab82eb84e23',
    messagingSenderId: '668706618778',
    projectId: 'to-do-55772',
    databaseURL: 'https://to-do-55772-default-rtdb.firebaseio.com',
    storageBucket: 'to-do-55772.appspot.com',
    androidClientId: '668706618778-k36ak01k6oa6oqmcu4rjn29f847mu8ot.apps.googleusercontent.com',
    iosClientId: '668706618778-omlq44ld1uqk9nuete4vcq4m7b4jn346.apps.googleusercontent.com',
    iosBundleId: 'com.example.fortress',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBiPFQodTtHxZW63EWEsNz76UcpzQ4Ohv0',
    appId: '1:668706618778:web:300936285d6105fcb84e23',
    messagingSenderId: '668706618778',
    projectId: 'to-do-55772',
    authDomain: 'to-do-55772.firebaseapp.com',
    databaseURL: 'https://to-do-55772-default-rtdb.firebaseio.com',
    storageBucket: 'to-do-55772.appspot.com',
  );
}
