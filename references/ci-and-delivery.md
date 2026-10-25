# CI and Delivery

Apply these conventions to new applications and to tasks that add or change CI/CD. In an existing repository, keep its CI provider, branch model, and scripts unless the task includes migrating them; map the rules below onto what is there.

The templates use GitHub Actions, Google Play, App Store Connect (TestFlight), and Firebase Hosting. Replace application IDs, environment variable names, and project IDs with the project's own values. Environments follow [environments-and-flavors.md](environments-and-flavors.md): `staging` and `production` are deployed; `local` is never built in CI.

The sample in `examples/reading_shelf` has no delivery targets, so it carries only the verified parts: `scripts/ci/write_config.sh`, the Android signing switch, `ios/ExportOptions.plist`, and a repository workflow that verifies the app and builds staging Web and an App Bundle from `config/ci.json` (debug-signed, because the repository has no upload key).

## Layout

```
.github/
  actions/setup-flutter/action.yml   # shared SDK setup (reads .fvmrc)
  workflows/
    ci.yml                           # verification for work branches
    verify.yml                       # reusable: generation, analysis, tests, generated diff
    staging.yml                      # develop PRs and pushes
    production.yml                   # release/hotfix PRs to main, main pushes
    deploy-android.yml               # reusable, per environment
    deploy-ios.yml                   # reusable, per environment
    deploy-web.yml                   # reusable, per environment
scripts/ci/
  write_config.sh                    # GitHub Environment variables -> config/ci.json
  upload_testflight.sh               # archive, sign, and upload iOS
ios/ExportOptions.plist
docs/ci.md                           # branch model, triggers, setup, secrets, release steps
```

Every deploy job `needs: verify`. One `environment` input names the GitHub Environment, the Flutter flavor, the Xcode scheme, and `APP_ENV` together, so the native flavor and Dart configuration cannot disagree.

## Triggers (Git Flow)

| Event | Workflow | Result |
| --- | --- | --- |
| Push to `feature/**`, `release/**`, `hotfix/**` | `ci.yml` | Verify only |
| PR to `develop` (opened or updated) | `staging.yml` | Verify → Play internal track (staging app), Hosting preview channel linked in a PR comment. No iOS. |
| Push to `develop` | `staging.yml` | Verify → Play internal track, TestFlight, Hosting staging `live` |
| PR from `release/*` or `hotfix/*` to `main` | `production.yml` | Verify → Play production track as **draft**, App Store Connect upload |
| Push to `main` | `production.yml` | Verify → Hosting production `live` |

Store review submission stays manual. If the repository does not use Git Flow, keep the same separation: work branches verify, the integration branch delivers to staging, and a gated release step delivers to production.

macOS runners cost more (ten times Linux minutes on private repositories), so iOS is built only on pushes to `develop` and on release PRs. Fork PRs receive no secrets: verify them, and guard every deploy job with `github.event.pull_request.head.repo.full_name == github.repository`.

## Shared setup action

```yaml
# .github/actions/setup-flutter/action.yml
name: Set up Flutter
description: Install the FVM-pinned Flutter SDK and resolve dependencies.
inputs:
  java:
    description: Install Java (needed for Android builds and OpenAPI Generator).
    default: 'false'
runs:
  using: composite
  steps:
    - uses: kuhnroyal/flutter-fvm-config-action@v3
      id: fvm-config
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: ${{ steps.fvm-config.outputs.FLUTTER_VERSION }}
        cache: true
    - if: inputs.java == 'true'
      uses: actions/setup-java@v6
      with:
        distribution: temurin
        java-version: '21'
    - shell: bash
      run: flutter pub get
```

If the app depends on a private repository (for example a git submodule), add a token input and use it only for that fetch, through a scoped `git config url.<...>.insteadOf`. `GITHUB_TOKEN` cannot read other repositories.

## Verification

```yaml
# .github/workflows/verify.yml
name: Verify
on:
  workflow_call:
jobs:
  verify:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v7
        with:
          persist-credentials: false
      - uses: ./.github/actions/setup-flutter
        with:
          java: 'true'
      - run: dart run build_runner build && flutter gen-l10n
      - run: flutter analyze lib test integration_test && flutter test
      # Only when the app has a generated API package.
      - run: sh scripts/verify_api.sh
      - run: git diff --exit-code -- lib packages/api_client pubspec.lock
```

```yaml
# .github/workflows/ci.yml
name: CI
# develop and main are verified by the staging and production workflows.
on:
  push:
    branches: ['feature/**', 'release/**', 'hotfix/**']
jobs:
  verify:
    uses: ./.github/workflows/verify.yml
```

`scripts/verify_api.sh` regenerates the API client in a clean copy without `.dart_tool` and `build`, runs the package's `pub get`, `build_runner`, `analyze`, and `test`, and compares the result with `diff -r` (see [api-client.md](api-client.md) and [testing-and-generation.md](testing-and-generation.md)). The final `git diff --exit-code` fails when committed generated code, localizations, or the lockfile are stale. Keep the generation step and the diff check in every app, including apps without an API package: drop only `verify_api.sh` and the package path. Analyze only directories that exist, such as `lib test` without `integration_test`. Pass `secrets: inherit` to `verify.yml` only when it needs a secret, such as a private dependency token.

## Configuration injection

CI never commits or reads developer config files. GitHub Environment variables are written to `config/ci.json`, which native builds pass with `--flavor` and web builds pass without it.

```sh
#!/bin/sh
# scripts/ci/write_config.sh: writes config/ci.json for --dart-define-from-file
# from GitHub Environment variables.
set -eu
cd "$(dirname "$0")/../.."
for name in APP_ENV API_BASE_URL SUPABASE_URL SUPABASE_PUBLISHABLE_KEY; do
  eval "value=\${$name:-}"
  if [ -z "$value" ]; then
    echo "error: $name is empty. Set it as a GitHub Environment variable." >&2
    exit 1
  fi
done
python3 -c 'import json, os, sys
keys = ["APP_ENV", "API_BASE_URL", "SUPABASE_URL", "SUPABASE_PUBLISHABLE_KEY"]
json.dump({k: os.environ[k] for k in keys}, sys.stdout, indent=2)' > config/ci.json
echo "Wrote config/ci.json for APP_ENV=$APP_ENV"
```

Keep the key list equal to the app's `AppConfig` defines. Add `config/ci.json` to `.gitignore`. Firebase options generated by FlutterFire are committed source, not CI variables.

## Secrets and variables

| Kind | Scope | Name | Content |
| --- | --- | --- | --- |
| Secret | Repository | `ANDROID_UPLOAD_KEYSTORE_BASE64` | `base64 -i upload.jks` of the upload keystore |
| Secret | Repository | `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD` | Keystore credentials |
| Secret | Repository | `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` | Play Console API service account |
| Secret | Repository | `ASC_KEY_ID`, `ASC_ISSUER_ID`, `ASC_PRIVATE_KEY` | App Store Connect API key (Admin role, `.p8` contents) |
| Secret | Environment | `FIREBASE_SERVICE_ACCOUNT` | Hosting deploy service account for that environment's project |
| Variable | Environment | `API_BASE_URL`, `SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY` | Public client values embedded in the app |
| Variable | Environment | `FIREBASE_PROJECT_ID` | That environment's Firebase project |
| Variable | Repository | `APPLE_TEAM_ID` | Apple Developer team ID used to sign iOS archives |

Values compiled into the client are public, so they are Variables, not Secrets. Never register Supabase secret or service-role keys, or any server credential, for app builds. Create `staging` and `production` GitHub Environments and add required reviewers to `production` when the team wants a manual gate.

## Workflow rules

- Check out with `persist-credentials: false`.
- Declare `permissions: contents: read` at workflow level and grant more only on the job that needs it. The Hosting deploy job needs `checks: write` and `pull-requests: write` for PR previews; set them on the calling `web` job, because a reusable workflow cannot get more than its caller grants. Verify, Android and iOS jobs keep `contents: read`.
- Use `concurrency` per PR or ref with `cancel-in-progress: false`, so an upload is never cut off halfway.
- Build numbers are `run_number * 100 + run_attempt`. Both stores reject a reused build number, and re-runs must upload too. GitHub allows at most 50 re-runs of a workflow run, so `run_attempt` stays below 100; a factor of 10 would collide from the tenth attempt. `run_number` counts per workflow, so deliver each store app from one workflow only. Version names come from `version` in `pubspec.yaml`; bump it on the release branch.
- Build the release artifact and upload it in the same job. Do not pass signing material between jobs.

## Staging and production

```yaml
# .github/workflows/staging.yml
name: Staging
on:
  pull_request:
    branches: [develop]
  push:
    branches: [develop]
concurrency:
  group: staging-${{ github.event.pull_request.number || github.ref }}
  cancel-in-progress: false
permissions:
  contents: read
jobs:
  verify:
    uses: ./.github/workflows/verify.yml
  android:
    needs: verify
    # Fork PRs have no secrets, so they are verified but never deployed.
    if: github.event_name == 'push' || github.event.pull_request.head.repo.full_name == github.repository
    uses: ./.github/workflows/deploy-android.yml
    secrets: inherit
    with:
      environment: staging
      package-name: com.example.app.staging
      track: internal
      status: completed
  ios:
    needs: verify
    # macOS minutes are expensive, so PRs skip iOS.
    if: github.event_name == 'push'
    uses: ./.github/workflows/deploy-ios.yml
    secrets: inherit
    with:
      environment: staging
  web:
    needs: verify
    if: github.event_name == 'push' || github.event.pull_request.head.repo.full_name == github.repository
    # Only the Hosting deploy writes checks and the PR preview comment.
    permissions:
      contents: read
      checks: write
      pull-requests: write
    uses: ./.github/workflows/deploy-web.yml
    secrets: inherit
    with:
      environment: staging
      # PRs get a preview channel; develop goes live.
      channel-id: ${{ github.event_name == 'push' && 'live' || '' }}
```

```yaml
# .github/workflows/production.yml
name: Production
on:
  pull_request:
    branches: [main]
    types: [opened, synchronize, reopened]
  push:
    branches: [main]
concurrency:
  group: production-${{ github.event.pull_request.number || github.ref }}
  cancel-in-progress: false
permissions:
  contents: read
jobs:
  verify:
    uses: ./.github/workflows/verify.yml
  android:
    needs: verify
    if: >-
      github.event_name == 'pull_request' &&
      github.event.pull_request.head.repo.full_name == github.repository &&
      (startsWith(github.head_ref, 'release/') || startsWith(github.head_ref, 'hotfix/'))
    uses: ./.github/workflows/deploy-android.yml
    secrets: inherit
    with:
      environment: production
      package-name: com.example.app
      track: production
      status: draft
  ios:
    needs: verify
    if: >-
      github.event_name == 'pull_request' &&
      github.event.pull_request.head.repo.full_name == github.repository &&
      (startsWith(github.head_ref, 'release/') || startsWith(github.head_ref, 'hotfix/'))
    uses: ./.github/workflows/deploy-ios.yml
    secrets: inherit
    with:
      environment: production
  web:
    needs: verify
    if: github.event_name == 'push'
    permissions:
      contents: read
      checks: write
      pull-requests: write
    uses: ./.github/workflows/deploy-web.yml
    secrets: inherit
    with:
      environment: production
```

## Android

Sign with the upload key only when CI provides it, so local and debug builds keep working:

```kotlin
// android/app/build.gradle.kts
android {
    val keystorePath = System.getenv("ANDROID_KEYSTORE_PATH")
    signingConfigs {
        if (keystorePath != null) {
            create("upload") {
                storeFile = file(keystorePath)
                storePassword = System.getenv("ANDROID_KEYSTORE_PASSWORD")
                keyAlias = System.getenv("ANDROID_KEY_ALIAS")
                keyPassword = System.getenv("ANDROID_KEY_PASSWORD")
            }
        }
    }
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName(if (keystorePath != null) "upload" else "debug")
        }
    }
}
```

```yaml
# .github/workflows/deploy-android.yml
name: Deploy Android
on:
  workflow_call:
    inputs:
      environment:
        description: GitHub Environment and Flutter flavor (staging|production).
        type: string
        required: true
      package-name:
        type: string
        required: true
      track:
        type: string
        required: true
      status:
        description: Google Play release status (completed|draft).
        type: string
        required: true
jobs:
  android:
    runs-on: ubuntu-latest
    environment: ${{ inputs.environment }}
    steps:
      - uses: actions/checkout@v7
        with:
          persist-credentials: false
      - uses: ./.github/actions/setup-flutter
        with:
          java: 'true'
      - name: Write config
        env:
          APP_ENV: ${{ inputs.environment }}
          API_BASE_URL: ${{ vars.API_BASE_URL }}
          SUPABASE_URL: ${{ vars.SUPABASE_URL }}
          SUPABASE_PUBLISHABLE_KEY: ${{ vars.SUPABASE_PUBLISHABLE_KEY }}
        run: sh scripts/ci/write_config.sh
      - name: Build app bundle
        env:
          FLAVOR: ${{ inputs.environment }}
          ANDROID_UPLOAD_KEYSTORE_BASE64: ${{ secrets.ANDROID_UPLOAD_KEYSTORE_BASE64 }}
          ANDROID_KEYSTORE_PATH: ${{ runner.temp }}/upload.jks
          ANDROID_KEYSTORE_PASSWORD: ${{ secrets.ANDROID_KEYSTORE_PASSWORD }}
          ANDROID_KEY_ALIAS: ${{ secrets.ANDROID_KEY_ALIAS }}
          ANDROID_KEY_PASSWORD: ${{ secrets.ANDROID_KEY_PASSWORD }}
          RUN_NUMBER: ${{ github.run_number }}
          RUN_ATTEMPT: ${{ github.run_attempt }}
        run: |
          echo "$ANDROID_UPLOAD_KEYSTORE_BASE64" | base64 -d > "$ANDROID_KEYSTORE_PATH"
          flutter build appbundle --release --flavor "$FLAVOR" \
            --dart-define-from-file=config/ci.json \
            --build-number=$((RUN_NUMBER * 100 + RUN_ATTEMPT))
      - uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.GOOGLE_PLAY_SERVICE_ACCOUNT_JSON }}
          packageName: ${{ inputs.package-name }}
          releaseFiles: build/app/outputs/bundle/${{ inputs.environment }}Release/app-${{ inputs.environment }}-release.aab
          tracks: ${{ inputs.track }}
          status: ${{ inputs.status }}
```

Google Play setup: create one Play Console app per flavor application ID and enable Play App Signing. The API cannot create an app's first release, so upload the first AAB of each app by hand. Grant the service account release permission on both apps.

## iOS

Archive the flavor's scheme with `xcodebuild` and sign automatically with an App Store Connect API key. The key needs the Admin role to create distribution certificates and profiles; no certificate export or renewal is needed.

```sh
#!/bin/sh
# scripts/ci/upload_testflight.sh: archives the FLAVOR scheme and uploads it to App Store Connect.
set -eu
cd "$(dirname "$0")/../.."
: "${FLAVOR:?}" "${APPLE_TEAM_ID:?}" "${ASC_KEY_ID:?}" "${ASC_ISSUER_ID:?}" "${ASC_PRIVATE_KEY:?}"

WORK="${RUNNER_TEMP:-$(mktemp -d)}"
KEY="$WORK/AuthKey_$ASC_KEY_ID.p8"
printf '%s\n' "$ASC_PRIVATE_KEY" > "$KEY"
AUTH="-allowProvisioningUpdates -authenticationKeyPath $KEY -authenticationKeyID $ASC_KEY_ID -authenticationKeyIssuerID $ASC_ISSUER_ID"

flutter build ios --config-only --release --flavor "$FLAVOR" \
  --dart-define-from-file=config/ci.json \
  --build-number=$((RUN_NUMBER * 100 + RUN_ATTEMPT))

# shellcheck disable=SC2086
xcodebuild -workspace ios/Runner.xcworkspace -scheme "$FLAVOR" \
  -configuration "Release-$FLAVOR" -destination 'generic/platform=iOS' \
  -archivePath "$WORK/Runner.xcarchive" $AUTH DEVELOPMENT_TEAM="$APPLE_TEAM_ID" archive

cp ios/ExportOptions.plist "$WORK/ExportOptions.plist"
/usr/libexec/PlistBuddy -c "Set :teamID $APPLE_TEAM_ID" "$WORK/ExportOptions.plist"
# shellcheck disable=SC2086
xcodebuild -exportArchive -archivePath "$WORK/Runner.xcarchive" \
  -exportOptionsPlist "$WORK/ExportOptions.plist" -exportPath "$WORK/export" $AUTH
```

`ios/ExportOptions.plist` sets `method` to `app-store-connect`, `destination` to `upload`, `signingStyle` to `automatic`, and `manageAppVersionAndBuildNumber` to `false` so the CI build number is kept. Leave its `teamID` empty: automatic signing needs the Apple Developer team for both the archive and the export, and the script passes `APPLE_TEAM_ID` to `DEVELOPMENT_TEAM` and to a copy of the plist, so the Xcode project does not need a team.

```yaml
# .github/workflows/deploy-ios.yml
name: Deploy iOS
on:
  workflow_call:
    inputs:
      environment:
        description: GitHub Environment, Flutter flavor and Xcode scheme.
        type: string
        required: true
jobs:
  ios:
    runs-on: macos-latest
    environment: ${{ inputs.environment }}
    steps:
      - uses: actions/checkout@v7
        with:
          persist-credentials: false
      - uses: ./.github/actions/setup-flutter
      - name: Write config
        env:
          APP_ENV: ${{ inputs.environment }}
          API_BASE_URL: ${{ vars.API_BASE_URL }}
          SUPABASE_URL: ${{ vars.SUPABASE_URL }}
          SUPABASE_PUBLISHABLE_KEY: ${{ vars.SUPABASE_PUBLISHABLE_KEY }}
        run: sh scripts/ci/write_config.sh
      - name: Build, sign and upload
        env:
          FLAVOR: ${{ inputs.environment }}
          APPLE_TEAM_ID: ${{ vars.APPLE_TEAM_ID }}
          ASC_KEY_ID: ${{ secrets.ASC_KEY_ID }}
          ASC_ISSUER_ID: ${{ secrets.ASC_ISSUER_ID }}
          ASC_PRIVATE_KEY: ${{ secrets.ASC_PRIVATE_KEY }}
          RUN_NUMBER: ${{ github.run_number }}
          RUN_ATTEMPT: ${{ github.run_attempt }}
        run: sh scripts/ci/upload_testflight.sh
```

App Store Connect setup: set `APPLE_TEAM_ID` to the team that owns the apps, register an App ID and create an app for each flavor bundle ID, and enable automatic distribution for an internal TestFlight group. After the first few builds, check that Apple Development certificates are not multiplying.

Prefer GitHub Actions over Xcode Cloud for flavored apps. Xcode Cloud products belong to one target and one app, so a single `Runner` target that switches bundle IDs per flavor cannot get a product for the staging app. Splitting platforms between two CI systems duplicates configuration, tokens, and logs.

## Web

```yaml
# .github/workflows/deploy-web.yml
name: Deploy Web
on:
  workflow_call:
    inputs:
      environment:
        type: string
        required: true
      channel-id:
        description: Firebase Hosting channel; empty creates a PR preview channel.
        type: string
        default: live
jobs:
  web:
    runs-on: ubuntu-latest
    environment: ${{ inputs.environment }}
    permissions:
      contents: read
      checks: write
      pull-requests: write
    steps:
      - uses: actions/checkout@v7
        with:
          persist-credentials: false
      - uses: ./.github/actions/setup-flutter
      - name: Write config
        env:
          APP_ENV: ${{ inputs.environment }}
          API_BASE_URL: ${{ vars.API_BASE_URL }}
          SUPABASE_URL: ${{ vars.SUPABASE_URL }}
          SUPABASE_PUBLISHABLE_KEY: ${{ vars.SUPABASE_PUBLISHABLE_KEY }}
        run: sh scripts/ci/write_config.sh
      # Web has no native flavor; the environment comes from the defines only.
      - run: flutter build web --release --dart-define-from-file=config/ci.json
      - uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: ${{ secrets.GITHUB_TOKEN }}
          firebaseServiceAccount: ${{ secrets.FIREBASE_SERVICE_ACCOUNT }}
          projectId: ${{ vars.FIREBASE_PROJECT_ID }}
          channelId: ${{ inputs.channel-id }}
```

`firebase.json` serves `build/web` as a single-page app; keep the project ID out of it and pass `FIREBASE_PROJECT_ID`. Give each environment's Hosting service account these roles: Firebase Hosting Admin, API Keys Viewer, Firebase Authentication Admin (to add preview URLs to authorized domains), and Service Usage Consumer (`roles/serviceusage.serviceUsageConsumer`; without it the Firebase CLI fails with a 403 on `serviceusage.services.get`).

## Documentation

Write `docs/ci.md` and link it from the README. It contains the branch model, the trigger table, the GitHub Environment and secrets table, per-store setup (including the manual first Play upload, API key roles, and the Apple team), the release steps, local equivalents of the CI builds, and a verification status that separates what was run locally from what stays unverified until the workflows run (signing, store uploads, Hosting deploys):

1. Branch `release/x.y.z` from `develop`, bump `version`, push.
2. Open a PR to `main`; store builds upload. Pushing fixes to the release branch uploads again.
3. Submit for review in the stores. After approval, merge the PR; the web production deploy runs.
4. Tag `vx.y.z` on the merge commit, then merge `main` back into `develop`.

```sh
APP_ENV=staging API_BASE_URL=... SUPABASE_URL=... SUPABASE_PUBLISHABLE_KEY=... sh scripts/ci/write_config.sh
fvm flutter build appbundle --release --flavor staging --dart-define-from-file=config/ci.json
fvm flutter build ios --release --no-codesign --flavor staging --dart-define-from-file=config/ci.json
fvm flutter build web --release --dart-define-from-file=config/ci.json
```

## Validation

- Run `actionlint` over `.github/` when it is available, and `shellcheck` over `scripts/ci/`.
- Run `write_config.sh` once with a missing variable (it must fail) and once with all values.
- Run the local equivalents above for each environment where the toolchain exists.
- Run the verification steps locally in the same order as `verify.yml`.

Report workflow validation and local builds separately from delivery. Store uploads, signing, Hosting deploys, and secret configuration cannot be proven without running the workflows in the real repository; state them as unverified until they have run.
