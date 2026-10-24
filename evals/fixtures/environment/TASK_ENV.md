# Environment task interface

The app currently has a single, implicit environment. It must support exactly
`local`, `staging`, and `production`.

## Configuration files

Commit these files with the given values. They are public endpoints, not secrets.

| File | `APP_ENV` | `API_BASE_URL` |
|---|---|---|
| `config/local.json` | `local` | `http://localhost:8080` |
| `config/staging.json` | `staging` | `https://staging.api.example.com` |
| `config/production.json` | `production` | `https://api.example.com` |

The files are passed with `--dart-define-from-file=config/<environment>.json`.
`API_BASE_URL` is not used by a backend yet; expose it with the resolved
environment so a future HTTP client can read it.

## Platforms

- Android and iOS select the environment with a native flavor named
  `local`, `staging`, or `production`. Production keeps the existing
  identifiers (`com.example.skill_eval_app` / `com.example.skillEvalApp`);
  local and staging can be installed beside it.
- Web is built without `--flavor`, for example
  `flutter build web --dart-define-from-file=config/staging.json`.

## Host and test interfaces

Keep `EvalApp({Key? key, required CatalogGateway gateway, Locale locale = const Locale('en')})`
in `lib/eval_app.dart`. `EvalApp` itself reflects the environment selected at compile time:
- local shows the text `LOCAL` and staging shows `STAGING` on screen, in English and Japanese;
- production shows neither.

The catalog list in `lib/catalog_screen.dart`, `lib/catalog_gateway.dart`, and
`lib/demo_gateway.dart` are unrelated to this task and must not change.
`flutter test` must pass without additional flags.
