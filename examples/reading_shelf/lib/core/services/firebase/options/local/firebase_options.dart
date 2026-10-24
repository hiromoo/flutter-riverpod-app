// Hand-owned Firebase Emulator configuration. Never run FlutterFire against local.
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

abstract final class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => android,
      TargetPlatform.iOS => ios,
      _ => throw UnsupportedError(
        'Local Firebase supports Android, iOS, and Web.',
      ),
    };
  }

  static const web = FirebaseOptions(
    apiKey: 'local-api-key',
    appId: '1:1234567890:web:local',
    messagingSenderId: '1234567890',
    projectId: 'demo-reading-shelf',
    authDomain: 'localhost',
  );
  static const android = FirebaseOptions(
    apiKey: 'local-api-key',
    appId: '1:1234567890:android:local',
    messagingSenderId: '1234567890',
    projectId: 'demo-reading-shelf',
  );
  static const ios = FirebaseOptions(
    apiKey: 'local-api-key',
    appId: '1:1234567890:ios:local',
    messagingSenderId: '1234567890',
    projectId: 'demo-reading-shelf',
    iosBundleId: 'com.example.readingshelf.local',
  );
}
