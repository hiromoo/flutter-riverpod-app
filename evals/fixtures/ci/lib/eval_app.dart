import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_config.dart';
import 'app_config_provider.dart';
import 'catalog_gateway.dart';
import 'catalog_screen.dart';
import 'l10n/app_localizations.dart';
import 'l10n/context_localizations.dart';
export 'catalog_gateway.dart';
export 'app_config.dart';

class EvalApp extends StatelessWidget {
  EvalApp({
    super.key,
    required this.gateway,
    this.locale = const Locale('en'),
    AppConfig? config,
  }) : config =
           config ??
           AppConfig.fromEnvironment(nativeFlavor: kIsWeb ? null : appFlavor);
  final CatalogGateway gateway;
  final Locale locale;
  final AppConfig config;
  @override
  Widget build(BuildContext context) => ProviderScope(
    retry: (_, _) => null,
    overrides: [appConfigProvider.overrideWithValue(config)],
    child: MaterialApp(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: (context, child) {
        final banner = switch (config.environment) {
          AppEnvironment.local => Semantics(
            container: true,
            label: context.l.localEnvironmentSemantics,
            child: Banner(
              message: context.l.localEnvironment,
              location: BannerLocation.topStart,
              color: Colors.teal,
              textDirection: TextDirection.ltr,
              child: child!,
            ),
          ),
          AppEnvironment.staging => Semantics(
            container: true,
            label: context.l.stagingEnvironmentSemantics,
            child: Banner(
              message: context.l.stagingEnvironment,
              location: BannerLocation.topStart,
              color: Colors.deepOrange,
              textDirection: TextDirection.ltr,
              child: child!,
            ),
          ),
          AppEnvironment.production => child!,
        };
        return banner;
      },
      home: CatalogScreen(gateway: gateway),
    ),
  );
}
