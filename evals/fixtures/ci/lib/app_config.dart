import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_config.freezed.dart';

enum AppEnvironment { local, staging, production }

@freezed
abstract class AppConfig with _$AppConfig {
  const factory AppConfig({
    required AppEnvironment environment,
    required String apiBaseUrl,
  }) = _AppConfig;

  static AppConfig fromEnvironment({String? nativeFlavor}) => resolve(
    appEnv: const String.fromEnvironment('APP_ENV'),
    apiBaseUrl: const String.fromEnvironment('API_BASE_URL'),
    nativeFlavor: nativeFlavor,
  );

  static AppConfig resolve({
    required String appEnv,
    required String apiBaseUrl,
    String? nativeFlavor,
  }) {
    if (appEnv.isEmpty) {
      throw const FormatException('APP_ENV is required.');
    }
    final environment = AppEnvironment.values.where(
      (value) => value.name == appEnv,
    );
    if (environment.isEmpty) {
      throw FormatException('Unknown APP_ENV: $appEnv.');
    }
    if (apiBaseUrl.isEmpty) {
      throw const FormatException('API_BASE_URL is required.');
    }
    if (nativeFlavor != null && nativeFlavor != appEnv) {
      throw FormatException(
        'Native flavor $nativeFlavor does not match APP_ENV $appEnv.',
      );
    }
    return AppConfig(environment: environment.single, apiBaseUrl: apiBaseUrl);
  }
}
