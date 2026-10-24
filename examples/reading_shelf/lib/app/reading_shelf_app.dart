import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/environment/app_config.dart';
import '../core/environment/environment_provider.dart';
import '../core/l10n/build_context_l10n.dart';
import '../features/settings/application/settings_providers.dart';
import '../features/settings/domain/app_settings.dart';
import '../l10n/generated/app_localizations.dart';
import 'app_theme.dart';
import 'router.dart';

class ReadingShelfApp extends ConsumerWidget {
  const ReadingShelfApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings =
        ref.watch(appSettingsControllerProvider).asData?.value ??
        const AppSettings();
    final environment = ref.watch(appConfigProvider).environment;
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: switch (settings.theme) {
        ThemePreference.system => ThemeMode.system,
        ThemePreference.light => ThemeMode.light,
        ThemePreference.dark => ThemeMode.dark,
      },
      locale: switch (settings.locale) {
        LocalePreference.system => null,
        LocalePreference.english => const Locale('en'),
        LocalePreference.japanese => const Locale('ja'),
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: appRouter,
      builder: (context, child) {
        if (environment == AppEnvironment.production) {
          return child ?? const SizedBox.shrink();
        }
        return Semantics(
          label: context.l.environmentBanner(environment.name),
          child: Banner(
            color: environment == AppEnvironment.local
                ? const Color(0xFF00796B)
                : const Color(0xFFBF360C),
            message: environment == AppEnvironment.local
                ? context.l.environmentLocal
                : context.l.environmentStaging,
            location: BannerLocation.topStart,
            layoutDirection: TextDirection.ltr,
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
