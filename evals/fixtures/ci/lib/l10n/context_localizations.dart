import 'package:flutter/widgets.dart';
import 'app_localizations.dart';

extension ContextLocalizations on BuildContext {
  AppLocalizations get l => AppLocalizations.of(this)!;
}
