import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reading_shelf/core/environment/app_config.dart';

void main() {
  const values = <String, String>{
    'apiBaseUrl': 'http://localhost:8080',
    'supabaseUrl': 'http://localhost:54321',
    'supabasePublishableKey': 'public-key',
    'firebaseEmulatorHost': '',
    'localHostOverride': '',
  };

  test('requires a known environment and rejects a native mismatch', () {
    expect(
      () => AppConfig.resolve(rawEnvironment: '', values: values),
      throwsFormatException,
    );
    expect(
      () => AppConfig.resolve(rawEnvironment: 'preview', values: values),
      throwsFormatException,
    );
    expect(
      () => AppConfig.resolve(
        rawEnvironment: 'staging',
        values: values,
        nativeFlavor: 'local',
      ),
      throwsFormatException,
    );
  });

  test('requires every configured cloud endpoint', () {
    final incomplete = {...values, 'supabasePublishableKey': ''};
    expect(
      () => AppConfig.resolve(rawEnvironment: 'staging', values: incomplete),
      throwsFormatException,
    );
  });

  test(
    'selects local emulator hosts by platform and supports device override',
    () {
      final local = AppConfig.resolve(rawEnvironment: 'local', values: values);
      expect(
        local.localServiceHost(isWeb: false, platform: TargetPlatform.android),
        '10.0.2.2',
      );
      expect(
        local.localServiceHost(isWeb: false, platform: TargetPlatform.iOS),
        'localhost',
      );
      expect(
        local.localServiceHost(isWeb: true, platform: TargetPlatform.android),
        'localhost',
      );
      final firebase = local.firebaseEmulators(
        isWeb: false,
        platform: TargetPlatform.android,
      );
      expect(firebase?.host, '10.0.2.2');
      expect(FirebaseEmulatorEndpoints.authPort, 9099);
      expect(FirebaseEmulatorEndpoints.firestorePort, 8081);

      final staging = AppConfig.resolve(
        rawEnvironment: 'staging',
        values: {
          ...values,
          'apiBaseUrl': 'https://api.example.com',
          'supabaseUrl': 'https://project.example.com',
        },
      );
      expect(
        staging.firebaseEmulators(isWeb: true, platform: TargetPlatform.iOS),
        isNull,
      );

      final device = AppConfig.resolve(
        rawEnvironment: 'local',
        values: {...values, 'localHostOverride': '192.168.1.25'},
      );
      expect(
        device.localServiceHost(isWeb: false, platform: TargetPlatform.android),
        '192.168.1.25',
      );
    },
  );
}
