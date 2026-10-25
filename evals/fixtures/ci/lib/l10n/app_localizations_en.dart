// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get localEnvironment => 'LOCAL';

  @override
  String get stagingEnvironment => 'STAGING';

  @override
  String get localEnvironmentSemantics => 'Local environment';

  @override
  String get stagingEnvironmentSemantics => 'Staging environment';
}
