import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/composition_root.dart';
import 'app/reading_shelf_app.dart';
import 'core/environment/app_config.dart';
import 'core/environment/environment_provider.dart';
import 'core/services/backend_services.dart';
import 'core/services/firebase/firebase_configuration.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = AppConfig.fromEnvironment(
    nativeFlavor: kIsWeb ? null : appFlavor,
  );
  final firebaseOptions = firebaseOptionsForEnvironment(config.environment);
  final backends = await BackendServices.initialize(
    config,
    firebaseOptions: firebaseOptions,
  );
  runApp(
    ProviderScope(
      retry: noAutomaticRetry,
      overrides: [
        appConfigProvider.overrideWithValue(config),
        backendServicesProvider.overrideWithValue(backends),
        ...createAppOverrides(config.apiUrl),
      ],
      child: const ReadingShelfApp(),
    ),
  );
}
