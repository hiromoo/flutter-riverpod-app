# Flutter environments and flavors

Apply these conventions to new applications and to tasks that introduce or change environment selection. Do not require unrelated feature work in an established app to migrate every environment.

## Environment contract

Use exactly `local`, `staging`, and `production` unless the project already has an explicit additional environment. Define an `AppEnvironment` enum and a Freezed `AppConfig` model. Read compile-time values once, validate them before initializing SDKs, and expose the resolved config through Riverpod. Keep environment parsing independent from service packages.

Read every value with `const String.fromEnvironment(...)` (or `bool`/`int` equivalents) in a const context. A non-const call is not guaranteed to see `--dart-define-from-file` values and silently returns the default. Keep the const reads in one factory and pass the raw values to a pure `resolve` function that tests call directly. A missing or empty `APP_ENV` is an error, not `local`: resolve the config in `main()` and fail before `runApp`, then override the config provider with the resolved value. If the project fixes a host widget that is constructed without an outer `ProviderScope` (for example, by an embedding host or a contract test), that widget owns the `ProviderScope`: it overrides the config provider with a value passed from `main()`, or falls back to the same const factory, so a missing `APP_ENV` fails the same way. Never make such a widget depend on a `ProviderScope` that only `main()` creates. Resolve the config once per widget instance, not in `build`:

```dart
class HostApp extends StatelessWidget {
  HostApp({super.key, AppConfig? config}) : config = config ?? AppConfig.fromEnvironment();
  final AppConfig config;

  @override
  Widget build(BuildContext context) => ProviderScope(
    retry: (_, _) => null,
    overrides: [appConfigProvider.overrideWithValue(config)],
    child: const _App(),
  );
}
```

`main()` resolves the config, failing before `runApp`, and passes it in: `runApp(HostApp(config: AppConfig.fromEnvironment(nativeFlavor: kIsWeb ? null : appFlavor)))`. Widgets read it through `appConfigProvider`.

If the host constructor is fixed and cannot take a `config` parameter, resolve it once in a top-level `final`, which Dart initializes on first access and then reuses:

```dart
final AppConfig resolvedAppConfig = AppConfig.fromEnvironment(nativeFlavor: kIsWeb ? null : appFlavor);
```

`main()` reads `resolvedAppConfig` before `runApp`, so a missing or invalid `APP_ENV` still fails at startup. The host widget's scope overrides `appConfigProvider` with the same value. Do not call `AppConfig.fromEnvironment` or `resolve` again in `build` or in the widget constructor. Tests inject a resolved `AppConfig` instead of depending on defines, so `flutter test` passes without flags. Add one widget test that pumps the root widget exactly as the host does.

Use `flutter_flavorizr` to create Android product flavors and iOS schemes/configurations. Pin an exact stable flavorizr version (for example `flutter_flavorizr: 2.6.0`, not a caret range) compatible with the project's pinned Flutter/Dart SDK. Keep flavor definitions in `flavorizr.yaml` and explicitly list only required processors (`android:androidManifest`, `android:buildGradle`, `android:flavorizrGradle`, `ios:xcconfig`, `ios:buildTargets`, `ios:schema`, `ios:plist`). Do not run IDE, Dart entrypoint, Firebase, icon, or launch-screen processors unless the task needs them. Review its diff on a clean tree before accepting generated changes. Android/iOS identifiers should distinguish non-production installs; retain the established production identifiers. Native flavor and `APP_ENV` must agree.

Web has no Flutter native flavor selection: run/build it without `--flavor`, and select configuration with `--dart-define-from-file=config/<environment>.json`. Native launch/build commands pass both their native flavor and the matching environment file. Never infer production from missing or invalid values. Reject unknown environments, required empty values, and native/Dart mismatches before SDK initialization.

## Service configuration

Keep service initialization in service-specific adapters or infrastructure modules. Compose them from the app bootstrap after validating `AppConfig`; expose initialized capabilities through Riverpod providers. Feature code depends on service-neutral repository contracts. This allows another backend to be added without changing environment parsing or banners.

For Supabase, local uses the Supabase CLI URL and its publishable key (`sb_publishable_...`, from `PUBLISHABLE_KEY` in CLI status output). Use Firebase CLI for authentication/project inspection and Emulator Suite, and FlutterFire CLI to generate a separate `firebase_options.dart` for staging and production. Select that environment's generated `DefaultFirebaseOptions.currentPlatform` in Firebase infrastructure before SDK initialization. Do not transcribe generated API keys/app IDs into JSON or require settings for other platforms at runtime. Keep JSON for environment selection, non-Firebase endpoints, and local host overrides.

Local uses hand-owned demo-project options (`demo-...`) and directs supported Auth/Firestore clients to Firebase Emulator Suite before first use. It must not require Firebase cloud login or FlutterFire configuration. Keep emulator host/port selection in Firebase infrastructure. Default local host to `10.0.2.2` on Android Emulator and `localhost` on iOS Simulator/Web; allow an explicit host override for physical devices. Never put service-role keys, Firebase service-account credentials, or other admin secrets in a Flutter app. Staging and production each receive their own project configuration; do not fall back across environments. Missing generated cloud options must produce an actionable error without preventing local builds.

Provide shareable JSON examples and keep developer-specific settings in ignored files or environment injection. Provide staging/production templates with conspicuous empty placeholders and fail clearly until populated. Firebase native files/options must match the selected environment and platform. Generated public client options may be reviewed and committed; authentication credentials and service accounts must stay out of source control. Do not hand-edit generated options. Provide a reproducible command/script with explicit project ID, native identifiers, Web app ID, and output path; do not silently create/select another project or choose the first available Web app. Record the verified CLI version and regenerate when adding platforms or Firebase products.

Assign native flavor identifiers/schemes to flavorizr, Firebase options and any necessary native service files to FlutterFire, and disable flavorizr's `google:firebase` processor. For Core/Auth/Firestore initialized with explicit options, Dart-only FlutterFire generation in an isolated temporary Flutter package can avoid adding native Google-services plugins/build phases that would require cloud files in local builds. See the sample's `scripts/configure_firebase.py`. If a Firebase product requires native integration, configure the environment-specific native paths and all affected iOS build configurations as well, then verify local still builds and `firebase.json` Emulator settings survive. Permit cleartext HTTP only in local Android configuration.

## UI and VS Code

Use Flutter's built-in `Banner`, the same component used by the default DEBUG banner, at the top-left (`BannerLocation.topStart` with LTR layout direction) for local and staging in every build mode. Keep its standard ribbon shape and typography, with distinct environment colors (for example, teal for local and deep orange for staging), short `LOCAL` / `STAGING` messages from ARB resources, and a localized semantic label. Read both through the shared `context.l` extension like every other string; do not call `AppLocalizations.of(context)` in the banner widget. Environment colors do not need to match the red DEBUG banner. Do not build a custom badge or inherit the app's headline text style. Production has no environment banner. Keep Flutter's default top-right DEBUG banner enabled. Create `.vscode/launch.json` with entries per environment and target class; it is a deliverable even when the task does not mention VS Code. Omit `deviceId` so the selected VS Code device is used. Native entries pass `--flavor` plus defines; web entries pass defines only.

## Validation

Test environment parsing and required fields, invalid values, native mismatch, local host selection/override, and platform-specific Firebase emulator routing. Test the badge in English and Japanese for local/staging and its absence in production. Verify all web environment builds omit `--flavor`, native identifiers are distinct as required, and re-running flavorizr does not overwrite hand-owned app or IDE files.

Document a table of run and build commands for every environment and platform: web (`flutter run -d chrome` and `flutter build web`, no `--flavor`), Android (`flutter run`/`flutter build apk --flavor <env>`), and iOS (`flutter run`/`flutter build ios --flavor <env>`), each with `--dart-define-from-file=config/<env>.json`. Document that `--dart-define-from-file` supplies compile-time Dart declarations rather than automatically reading OS environment variables, and changing them requires a full restart/rebuild. Include preparation and startup commands per environment and identify the existing backend endpoints required. Report build verification separately from actual service connectivity, authorization, and distribution signing/deployment; a successful build with placeholder settings does not establish that a cloud environment works.

For new Supabase client configuration, use `SUPABASE_PUBLISHABLE_KEY` and `Supabase.initialize(publishableKey: ...)`, not the legacy anon-key parameter or a legacy JWT placeholder. Follow the [Supabase API-key migration guide](https://supabase.com/docs/guides/getting-started/migrating-to-new-api-keys) when updating an existing app. Publishable keys are not user access-token JWTs; let the SDK handle API-key headers and user authentication. Secret keys (`sb_secret_...`) and legacy service-role keys are server-only and must never enter Flutter configuration. Do not deactivate existing project keys as part of client configuration work.
