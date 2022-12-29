import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;

      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyByoqLAnSuFnqjhtq0iPbgpYock9IEjbzA',
    appId: '1:1089637168277:android:2aa955de5ce8d71bc4979c',
    messagingSenderId: '1089637168277',
    projectId: 'pickupjob-f5bab',
    databaseURL: 'https://pickupjob-f5bab-default-rtdb.firebaseio.com',
    storageBucket: 'pickupjob-f5bab.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCmelMYVZXfNiv9sWe4DvOyqeyVB5oP5Lk',
    appId: '1:1089637168277:ios:970029aad386ae49c4979c',
    messagingSenderId: '1089637168277',
    projectId: 'pickupjob-f5bab',
    databaseURL: 'https://pickupjob-f5bab-default-rtdb.firebaseio.com',
    storageBucket: 'pickupjob-f5bab.appspot.com',
    androidClientId:
        '1089637168277-omv0nlrepel91n5rieb6omi2vcleev1v.apps.googleusercontent.com',
    iosClientId:
        '1089637168277-re5ec07scppb3jcvrjs6rlj7ael4e1cq.apps.googleusercontent.com',
    iosBundleId: 'io.flutter.plugins.firebase.messaging',
  );
}
