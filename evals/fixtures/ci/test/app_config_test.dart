import 'package:flutter_test/flutter_test.dart';
import 'package:skill_eval_app/app_config.dart';

void main() {
  group('AppConfig.resolve', () {
    test('resolves the supported environments and endpoint', () {
      for (final environment in AppEnvironment.values) {
        final config = AppConfig.resolve(
          appEnv: environment.name,
          apiBaseUrl: 'https://${environment.name}.example.com',
        );
        expect(config.environment, environment);
        expect(config.apiBaseUrl, 'https://${environment.name}.example.com');
      }
    });

    test('rejects missing and unknown environments and endpoint', () {
      expect(
        () => AppConfig.resolve(
          appEnv: '',
          apiBaseUrl: 'https://api.example.com',
        ),
        throwsFormatException,
      );
      expect(
        () => AppConfig.resolve(
          appEnv: 'qa',
          apiBaseUrl: 'https://api.example.com',
        ),
        throwsFormatException,
      );
      expect(
        () => AppConfig.resolve(appEnv: 'local', apiBaseUrl: ''),
        throwsFormatException,
      );
    });

    test('rejects a mismatch between native flavor and Dart environment', () {
      expect(
        () => AppConfig.resolve(
          appEnv: 'staging',
          apiBaseUrl: 'https://api.example.com',
          nativeFlavor: 'local',
        ),
        throwsFormatException,
      );
    });
  });
}
