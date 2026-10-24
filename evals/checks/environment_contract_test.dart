import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skill_eval_app/eval_app.dart';

const environment = String.fromEnvironment('APP_ENV');
class Gateway implements CatalogGateway {
  @override
  Future<List<Map<String, dynamic>>> search(String query) async =>
      [{'id': 'a', 'title': 'Title a', 'description': 'Description a'}];
  @override
  Future<Map<String, dynamic>> get(String id) async => {'id': id, 'title': 'Title $id', 'description': ''};
}
bool shows(WidgetTester tester, String label) =>
    tester.widgetList<Banner>(find.byType(Banner)).any((b) => b.message == label) ||
    find.textContaining(label).evaluate().isNotEmpty;
Iterable<File> files(String dir, bool Function(String) match) => Directory(dir).existsSync()
    ? Directory(dir).listSync(recursive: true).whereType<File>().where((f) => match(f.path))
    : const [];
void main() {
  for (final language in ['en', 'ja']) {
    testWidgets('$language environment indicator for "$environment"', (tester) async {
      await tester.pumpWidget(EvalApp(gateway: Gateway(), locale: Locale(language)));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Title a'), findsOneWidget);
      expect(shows(tester, 'LOCAL'), environment == 'local');
      expect(shows(tester, 'STAGING'), environment == 'staging');
    });
  }
  test('native flavors are declared', () {
    final gradle = files('android/app', (p) => p.endsWith('.gradle') || p.endsWith('.gradle.kts'))
        .map((f) => f.readAsStringSync()).join('\n');
    expect(gradle, contains('productFlavors'));
    for (final name in ['local', 'staging', 'production']) {
      expect(gradle, matches(RegExp('(create\\(\\s*"$name"|\\b$name\\s*\\{)')));
      expect(File('ios/Runner.xcodeproj/xcshareddata/xcschemes/$name.xcscheme').existsSync(), isTrue, reason: name);
    }
  });
}
