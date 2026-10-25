// Bootstrap placeholder. Replace this entire file with FlutterFire CLI output.
// Do not fill cloud settings in by hand.
import 'package:firebase_core/firebase_core.dart';

abstract final class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => throw StateError(
    'Firebase staging is not configured. Run python3 scripts/configure_firebase.py '
    'staging <firebase-project-id> <firebase-web-app-id>.',
  );
}
