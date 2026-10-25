import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'demo_gateway.dart';
import 'eval_app.dart';

void main() {
  final config = AppConfig.fromEnvironment(
    nativeFlavor: kIsWeb ? null : appFlavor,
  );
  runApp(EvalApp(gateway: const DemoGateway(), config: config));
}
