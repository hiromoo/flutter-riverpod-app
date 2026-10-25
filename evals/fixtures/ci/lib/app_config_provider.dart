import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_config.dart';

final appConfigProvider = Provider<AppConfig>(
  (ref) => throw StateError('AppConfig must be provided by EvalApp.'),
);
