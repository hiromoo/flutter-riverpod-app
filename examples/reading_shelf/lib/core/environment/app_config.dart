import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'app_config.freezed.dart';

enum AppEnvironment { local, staging, production }

@freezed
abstract class FirebaseEmulatorEndpoints with _$FirebaseEmulatorEndpoints {
  const factory FirebaseEmulatorEndpoints({required String host}) =
      _FirebaseEmulatorEndpoints;
  static const authPort = 9099;
  static const firestorePort = 8081;
}

@freezed
abstract class AppConfig with _$AppConfig {
  const factory AppConfig({
    required AppEnvironment environment,
    required String apiBaseUrl,
    required String supabaseUrl,
    required String supabasePublishableKey,
    @Default('') String firebaseEmulatorHost,
    @Default('') String localHostOverride,
  }) = _AppConfig;

  const AppConfig._();

  factory AppConfig.fromEnvironment({String? nativeFlavor}) {
    const rawEnvironment = String.fromEnvironment('APP_ENV');
    const config = {
      'apiBaseUrl': String.fromEnvironment('API_BASE_URL'),
      'supabaseUrl': String.fromEnvironment('SUPABASE_URL'),
      'supabasePublishableKey': String.fromEnvironment(
        'SUPABASE_PUBLISHABLE_KEY',
      ),
      'firebaseEmulatorHost': String.fromEnvironment('FIREBASE_EMULATOR_HOST'),
      'localHostOverride': String.fromEnvironment('LOCAL_HOST_OVERRIDE'),
    };
    return AppConfig.resolve(
      rawEnvironment: rawEnvironment,
      values: config,
      nativeFlavor: nativeFlavor,
    );
  }

  static AppConfig resolve({
    required String rawEnvironment,
    required Map<String, String> values,
    String? nativeFlavor,
  }) {
    if (rawEnvironment.isEmpty) {
      throw const FormatException('APP_ENV is required.');
    }
    final environment = AppEnvironment.values.where(
      (value) => value.name == rawEnvironment,
    );
    if (environment.isEmpty) {
      throw FormatException('Unknown APP_ENV: $rawEnvironment');
    }
    if (nativeFlavor != null && nativeFlavor != rawEnvironment) {
      throw FormatException(
        'Native flavor "$nativeFlavor" does not match APP_ENV "$rawEnvironment".',
      );
    }
    final env = environment.single;
    const requiredKeys = [
      'apiBaseUrl',
      'supabaseUrl',
      'supabasePublishableKey',
    ];
    final missing = requiredKeys
        .where((key) => (values[key] ?? '').isEmpty)
        .toList();
    if (missing.isNotEmpty) {
      throw FormatException(
        'Missing ${env.name} configuration: ${missing.join(', ')}',
      );
    }
    if (env != AppEnvironment.local &&
        (values['firebaseEmulatorHost'] ?? '').isNotEmpty) {
      throw const FormatException(
        'FIREBASE_EMULATOR_HOST is only valid for local.',
      );
    }
    if (env != AppEnvironment.local &&
        (values['localHostOverride'] ?? '').isNotEmpty) {
      throw const FormatException(
        'LOCAL_HOST_OVERRIDE is only valid for local.',
      );
    }
    for (final key in ['apiBaseUrl', 'supabaseUrl']) {
      final uri = Uri.tryParse(values[key] ?? '');
      if (uri == null ||
          !uri.hasAuthority ||
          !['http', 'https'].contains(uri.scheme)) {
        throw FormatException('$key must be an absolute HTTP(S) URL.');
      }
      if (env != AppEnvironment.local && uri.scheme != 'https') {
        throw FormatException('$key must use HTTPS for ${env.name}.');
      }
    }
    return AppConfig(
      environment: env,
      apiBaseUrl: values['apiBaseUrl']!,
      supabaseUrl: values['supabaseUrl']!,
      supabasePublishableKey: values['supabasePublishableKey']!,
      firebaseEmulatorHost: values['firebaseEmulatorHost'] ?? '',
      localHostOverride: values['localHostOverride'] ?? '',
    );
  }

  String get apiUrl => _localizeUrl(apiBaseUrl);
  String get supabaseEndpoint => _localizeUrl(supabaseUrl);

  String _localizeUrl(String value) {
    if (environment != AppEnvironment.local) return value;
    final uri = Uri.parse(value);
    final host = localServiceHost(
      isWeb: kIsWeb,
      platform: defaultTargetPlatform,
    );
    return uri
        .replace(host: uri.host == 'localhost' ? host : uri.host)
        .toString();
  }

  String localServiceHost({
    required bool isWeb,
    required TargetPlatform platform,
  }) {
    if (localHostOverride.isNotEmpty) return localHostOverride;
    if (firebaseEmulatorHost.isNotEmpty) return firebaseEmulatorHost;
    if (isWeb || platform == TargetPlatform.iOS) return 'localhost';
    if (platform == TargetPlatform.android) return '10.0.2.2';
    return 'localhost';
  }

  FirebaseEmulatorEndpoints? firebaseEmulators({
    required bool isWeb,
    required TargetPlatform platform,
  }) => environment == AppEnvironment.local
      ? FirebaseEmulatorEndpoints(
          host: localServiceHost(isWeb: isWeb, platform: platform),
        )
      : null;
}
