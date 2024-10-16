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
    apiKey: 'AIzaSyALXtV7KONM4WcKhLp8nTYTdIP7rYabee8',
    appId: '1:556333518989:web:de4a300c274b87240652c4',
    messagingSenderId: '556333518989',
    projectId: 'seguridad-278d6',
    authDomain: 'seguridad-278d6.firebaseapp.com',
    storageBucket: 'seguridad-278d6.appspot.com',
    measurementId: 'G-ZSNLJ6QGSH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCSOaL4LpCXFmFwdV_ysI6aqr7Rh_kThlw',
    appId: '1:556333518989:android:69e6cc3f0520c20d0652c4',
    messagingSenderId: '556333518989',
    projectId: 'seguridad-278d6',
    storageBucket: 'seguridad-278d6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCMgYxd1AeMXvcrs0NBcKdqX_1zCj5xh-A',
    appId: '1:556333518989:ios:11724dc9b8f5c73d0652c4',
    messagingSenderId: '556333518989',
    projectId: 'seguridad-278d6',
    storageBucket: 'seguridad-278d6.appspot.com',
    iosBundleId: 'com.example.appUserController',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCMgYxd1AeMXvcrs0NBcKdqX_1zCj5xh-A',
    appId: '1:556333518989:ios:11724dc9b8f5c73d0652c4',
    messagingSenderId: '556333518989',
    projectId: 'seguridad-278d6',
    storageBucket: 'seguridad-278d6.appspot.com',
    iosBundleId: 'com.example.appUserController',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyALXtV7KONM4WcKhLp8nTYTdIP7rYabee8',
    appId: '1:556333518989:web:0f82bc9c4d3a69fe0652c4',
    messagingSenderId: '556333518989',
    projectId: 'seguridad-278d6',
    authDomain: 'seguridad-278d6.firebaseapp.com',
    storageBucket: 'seguridad-278d6.appspot.com',
    measurementId: 'G-YSJVGYBRC7',
  );
}
