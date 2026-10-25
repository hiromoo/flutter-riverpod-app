# Existing Flutter application fixture

Flutter 3.47.8 / Dart 3.13.7, managed by the existing `.fvmrc`.
Use the provided pinned SDK; dependencies are prepared before the task starts.
The installed dependencies are available building blocks, not a required architecture.

## Stable host and test interfaces

UI tasks must expose `EvalApp({Key? key, required CatalogGateway gateway, Locale locale = const Locale('en')})`
from `lib/eval_app.dart`, and export `CatalogGateway` from that library.
The app includes its own MaterialApp (or MaterialApp.router).
The injected gateway is a transport seam returning JSON-like book objects
with string `id`, `title`, and `description` fields. Do not change its interface.

Search UI: a TextField with key `search-input`; submitting it starts a search.
An initial search uses the empty query. Results show book titles with tap targets
keyed `book-<id>`. Show a CircularProgressIndicator while loading,
`No books` / `本がありません` for empty results, and a button `Retry` / `再試行`
with key `retry` after an error. Retry repeats the failed query.
Locale comes from the host constructor. Feature-task book details must show
both title and description, including after opening the book from the list.

API tasks instead retain the public signatures documented in their task README.

## Environments

`config/local.json`, `config/staging.json`, and `config/production.json` define
the public API base URLs. `AppConfig` validates the selected environment and
URL before startup; application code can read the resolved values through
`appConfigProvider`. Local and staging show a localized environment ribbon.

`--dart-define-from-file` supplies compile-time Dart declarations. It does not
read operating system environment variables. Restart the app or rebuild after
changing a define. Native mobile flavors and the `APP_ENV` value must agree.

| Environment | Web run / build | Android run / build | iOS run / build |
| --- | --- | --- | --- |
| local | `flutter run -d chrome --dart-define-from-file=config/local.json` / `flutter build web --dart-define-from-file=config/local.json` | `flutter run --flavor local --dart-define-from-file=config/local.json` / `flutter build apk --debug --flavor local --dart-define-from-file=config/local.json` | `flutter run --flavor local --dart-define-from-file=config/local.json` / `flutter build ios --simulator --no-codesign --flavor local --dart-define-from-file=config/local.json` |
| staging | `flutter run -d chrome --dart-define-from-file=config/staging.json` / `flutter build web --dart-define-from-file=config/staging.json` | `flutter run --flavor staging --dart-define-from-file=config/staging.json` / `flutter build apk --debug --flavor staging --dart-define-from-file=config/staging.json` | `flutter run --flavor staging --dart-define-from-file=config/staging.json` / `flutter build ios --simulator --no-codesign --flavor staging --dart-define-from-file=config/staging.json` |
| production | `flutter run -d chrome --dart-define-from-file=config/production.json` / `flutter build web --dart-define-from-file=config/production.json` | `flutter run --flavor production --dart-define-from-file=config/production.json` / `flutter build apk --debug --flavor production --dart-define-from-file=config/production.json` | `flutter run --flavor production --dart-define-from-file=config/production.json` / `flutter build ios --simulator --no-codesign --flavor production --dart-define-from-file=config/production.json` |

Web does not use `--flavor`. For native builds, select the matching flavor and
defines file. `flutter_flavorizr` is pinned to 2.6.0; regenerate native flavor
files with `dart run flutter_flavorizr` and select the listed processors in
`flavorizr.yaml`.

These are demo catalog builds; no backend client currently connects to the API
URLs. When one is added, local development requires a service listening at
`http://localhost:8080`; staging and production use their configured API
endpoints. Build success does not validate service connectivity, authorization,
signing, or deployment.

References: [Flutter flavors](https://docs.flutter.dev/deployment/flavors),
[Dart environment declarations](https://dart.dev/libraries/core/environment-declarations),
[flutter_flavorizr 2.6.0](https://pub.dev/packages/flutter_flavorizr/versions/2.6.0).
