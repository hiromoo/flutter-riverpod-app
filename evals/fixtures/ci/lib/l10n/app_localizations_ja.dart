// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get localEnvironment => 'LOCAL';

  @override
  String get stagingEnvironment => 'STAGING';

  @override
  String get localEnvironmentSemantics => 'ローカル環境';

  @override
  String get stagingEnvironmentSemantics => 'ステージング環境';
}
