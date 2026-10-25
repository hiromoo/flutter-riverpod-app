import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skill_eval_app/eval_app.dart';

class _EmptyGateway implements CatalogGateway {
  @override
  Future<List<Map<String, dynamic>>> search(String query) async => [];

  @override
  Future<Map<String, dynamic>> get(String id) async => {};
}

void main() {
  for (final environment in [AppEnvironment.local, AppEnvironment.staging]) {
    for (final locale in [const Locale('en'), const Locale('ja')]) {
      testWidgets(
        '${environment.name} banner is localized for ${locale.languageCode}',
        (tester) async {
          await tester.pumpWidget(
            EvalApp(
              gateway: _EmptyGateway(),
              locale: locale,
              config: AppConfig(
                environment: environment,
                apiBaseUrl: 'https://api.example.com',
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(
            find.byWidgetPredicate(
              (widget) =>
                  widget is Banner &&
                  widget.message == environment.name.toUpperCase(),
            ),
            findsOneWidget,
          );
          final semantics = environment == AppEnvironment.local
              ? (locale.languageCode == 'ja' ? 'ローカル環境' : 'Local environment')
              : (locale.languageCode == 'ja'
                    ? 'ステージング環境'
                    : 'Staging environment');
          expect(
            find.byWidgetPredicate(
              (widget) =>
                  widget is Semantics && widget.properties.label == semantics,
            ),
            findsOneWidget,
          );
        },
      );
    }
  }

  testWidgets('production has no environment banner', (tester) async {
    await tester.pumpWidget(
      EvalApp(
        gateway: _EmptyGateway(),
        config: const AppConfig(
          environment: AppEnvironment.production,
          apiBaseUrl: 'https://api.example.com',
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('LOCAL'), findsNothing);
    expect(find.text('STAGING'), findsNothing);
  });
}
