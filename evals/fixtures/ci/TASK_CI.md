# CI/CD task interface

The app already supports `local`, `staging`, and `production` (see README.md).
Add CI/CD on GitHub Actions. Only `staging` and `production` are delivered.

## Branches

- Work happens on `feature/*` branches, merged into `develop` by pull request.
- `develop` is the staging line. Every change merged into it is delivered to staging.
- Releases branch from `develop` as `release/x.y.z`; urgent fixes branch from `main`
  as `hotfix/*`. Both are merged into `main` by pull request.
- `main` is the production line. Store submission for review stays a manual step.
- The repository is private. Pull requests may come from forks.

## Delivery targets

| Environment | Android (Google Play) | iOS (App Store Connect) | Web (Firebase Hosting) |
|---|---|---|---|
| staging | `com.example.skill_eval_app.staging`, internal testing | `com.example.skillEvalApp.staging`, TestFlight | staging project |
| production | `com.example.skill_eval_app`, production track for review | `com.example.skillEvalApp`, App Store review | production project |

Firebase project IDs differ per environment and are not committed.
The store apps, signing keys, API keys, and service accounts will be created by the
maintainers from your documentation; none exist in the repository.

## Constraints

- `lib/`, `test/`, `config/`, `flavorizr.yaml`, and `.fvmrc` must not change.
- `flutter test` passes without flags, and local release builds keep working on a
  machine without any signing secrets.
- No credential of any kind may be committed.
