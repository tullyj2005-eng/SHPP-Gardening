import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return web;
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDzfyJYzB7g88566G2PUS5KDmYjByR6fEA',
    appId: '1:334740903380:web:d320103e58668bd95b3241',
    messagingSenderId: '334740903380',
    projectId: 'shpp-gardening',
    authDomain: 'shpp-gardening.firebaseapp.com',
    storageBucket: 'shpp-gardening.firebasestorage.app',
  );
}