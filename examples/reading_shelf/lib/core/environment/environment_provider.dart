import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_config.dart';

part 'environment_provider.g.dart';

@Riverpod(keepAlive: true)
AppConfig appConfig(Ref ref) => AppConfig.fromEnvironment();
