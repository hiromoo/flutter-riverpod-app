import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reading_shelf/core/environment/app_config.dart';
import 'package:reading_shelf/core/services/firebase/firebase_configuration.dart';
import 'package:reading_shelf/core/services/firebase/options/local/firebase_options.dart'
    as local;

void main() {
  tearDown(() => debugDefaultTargetPlatformOverride = null);

  test(
    'local uses platform-specific demo options without cloud configuration',
    () {
      for (final platform in [TargetPlatform.android, TargetPlatform.iOS]) {
        debugDefaultTargetPlatformOverride = platform;
        final options = firebaseOptionsForEnvironment(AppEnvironment.local);
        expect(options.projectId, 'demo-reading-shelf');
        expect(
          options.appId,
          contains(platform == TargetPlatform.android ? ':android:' : ':ios:'),
        );
      }
      expect(local.DefaultFirebaseOptions.web.projectId, 'demo-reading-shelf');
      expect(local.DefaultFirebaseOptions.web.appId, contains(':web:'));
    },
  );

  test('cloud configuration never silently falls back to the demo project', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    for (final environment in [
      AppEnvironment.staging,
      AppEnvironment.production,
    ]) {
      try {
        final options = firebaseOptionsForEnvironment(environment);
        expect(options.projectId, isNot('demo-reading-shelf'));
        expect(options.appId, contains(':android:'));
      } on StateError catch (error) {
        // Bootstrap placeholders remain buildable until the user runs FlutterFire.
        expect(
          error.message,
          contains('configure_firebase.py ${environment.name}'),
        );
      }
    }
  });
}
