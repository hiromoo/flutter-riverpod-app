---
name: flutter-riverpod-skill
description: Build and evolve Flutter applications with Riverpod, Freezed, Dio clients generated from OpenAPI, Flutter localization, consistent Material theming, and type-safe go_router navigation. Use for new apps, feature work, and incremental architecture refactors.
---

# Riverpod Flutter Application Engineering

Apply this skill when creating a Flutter application, adding a feature, or incrementally improving an existing application that uses Riverpod.

## Core rules

- Follow Flutter's [architecture best practices skill](https://github.com/flutter/agent-plugins/blob/main/skills/flutter-apply-architecture-best-practices/SKILL.md) as the architectural baseline. Add Riverpod-specific guidance from this skill; do not copy the external skill into the project.
- Use feature-first organization, with clear presentation, application, domain, and data responsibilities. Keep dependencies pointing inward; UI and domain code must not depend on Dio or generated API classes.
- Use Riverpod `Notifier`/`AsyncNotifier` for application and presentation state. A separate ViewModel is optional. Use `flutter_hooks` for widget-local, disposable state; use `hooks_riverpod` where a widget needs both hooks and Riverpod.
- Use Freezed for domain models, app state, and value objects. Generated OpenAPI DTOs are exempt and must remain generator-owned.
- For APIs described by OpenAPI, generate the client with OpenAPI Generator's stable `dart-dio` generator. Keep generated code behind data adapters and repositories.
- Use Flutter `gen_l10n` with ARB files for all user-facing text. The app's supported locales start with English and Japanese. Expose generated localizations as `context.l.*` through a `BuildContext` extension.
- Centralize Material theme configuration in `MaterialApp.router`; use `go_router` and `go_router_builder` typed routes for navigation.
- For new Flutter projects, pin the verified Flutter SDK with FVM in `.fvmrc` and use that SDK in local commands, IDE settings, and CI. In an existing project, preserve its established SDK manager unless the task includes migrating it.
- Inspect the target repository before editing. Preserve established conventions where they do not conflict with these requirements, and migrate existing applications incrementally by feature.

## Scope: which code must follow the conventions

The conventions apply to every file the task creates, rewrites, or moves. Code the task does not touch can stay as it is.

- Incremental migration limits *which features* change. It does not permit writing new code that breaks a convention. When a task rewrites a screen, the rewritten screen follows the conventions even if neighbouring screens do not.
- The patterns inside the code being replaced are not conventions to preserve. Examples are inline JSON maps, hard-coded strings, locale `if` branches, `Navigator.push`, and `StatefulWidget` controllers. Preserve project-wide infrastructure instead: the SDK manager, package layout, public interfaces, CI, and unrelated features.
- A small task is not an exemption. A two-screen feature still gets a Freezed model, ARB strings with `context.l`, and typed routes. Keep it proportionate by adding only the files those conventions need. Skip empty layers and speculative abstractions.
- If an explicit project requirement or host interface forbids a convention, follow the requirement. Satisfy the convention behind that interface, and name the exception in the final summary.

## Convention checklist

Each row is triggered by something the task produces. Every triggered row is mandatory for the code the task touches.

| Trigger in the task | Required outcome | Evidence to check before finishing |
| --- | --- | --- |
| Data arrives as JSON, maps, DTOs, or generated API types | A data-layer adapter or repository maps it to domain models. Notifiers and widgets never read transport keys or DTOs. | No `['key']` map access, `Map<String, dynamic>`, DTO, `Optional`, or Dio import outside `data/`. |
| A hand-written model, entity, value object, or non-trivial state crosses a layer or is exposed publicly. This includes any plain public data class already present in a file the task edits, such as a class with only `final` fields and a `const` constructor. Convert it even when the task only asks you to keep its constructor signature. | The type is a `@freezed` class with generated output committed and compiling. To keep an existing constructor signature, use a matching `const factory`, for example `const factory ReadingRecord({required String id, String? note}) = _ReadingRecord;`. Records are only for private, single-file tuples. | `part '*.freezed.dart'` exists and `build_runner` produced it. No plain public data class is left in touched files. |
| Remote, shared, async, or cross-widget state | Riverpod `Notifier`/`AsyncNotifier` or a provider owns the state. Its lifecycle is explicit (autoDispose/family). Prefer a provider family keyed by the request parameters, such as the query or id; each key then has its own lifecycle and old requests cannot overwrite newer ones. When one notifier handles changing parameters, every async entry point, including the initial load from `build()`, goes through one guarded helper. The helper takes a request id, awaits the work, catches errors, and then applies the result only if `ref.mounted` is true and the id is still the latest. No path assigns `state`, or returns a `build()` result or error, without that check. | Widgets do not hold remote state. Tests cover out-of-order completion when requests can overlap. That includes a new request that starts while the initial load is still pending, in both orders: the earlier request fails after the later one succeeds, and succeeds after the later one fails. Tests also cover a request that completes after the provider or its widget is disposed, and assert that no exception is thrown. |
| Retry or refresh after a failure | Every error state, on list and detail screens alike, shows a retry action. Retry resends exactly the parameters of the failed request, such as the query, page, or id. With a family, retry invalidates that family key, for example `ref.invalidate(bookSearchProvider(query: query, page: page))`. With a single notifier, the notifier stores the failed parameters and `retry()` resends them. The retry button never reads input controllers again. With a family, resubmitting the same parameters must still start a new request: invalidate or refresh that key instead of only reassigning it. | A test edits the input after a failure, taps retry, and asserts that the failed parameters were requested again. Another test submits the same query twice and asserts two requests. Each error state in the UI has a retry test. |
| `TextEditingController`, `FocusNode`, `AnimationController`, `ScrollController`, or other widget-local disposable state | `HookWidget`/`HookConsumerWidget` with `useTextEditingController` and similar hooks. No `StatefulWidget` or `State` fields. | No new `StatefulWidget` was added for local state. |
| Any user-visible string, including errors, empty states, button labels, and semantics | The string is an ARB key in `app_en.arb` and `app_ja.arb`, generated by `gen_l10n`, and read through one shared `context.l` extension. | No string literals or locale `if` branches in widgets. `AppLocalizations.of(context)` appears only inside the extension. |
| Moving between screens, or a new screen reachable by navigation | `MaterialApp.router` with `go_router`. Routes are `GoRouteData` classes generated by `go_router_builder`, and navigation calls `SomeRoute(...).go/push(context)`. The theme is set on `MaterialApp.router`. | No `Navigator.push`, `MaterialPageRoute`, or string paths for in-app navigation. `*.g.dart` route output exists. |
| A new application, or a task that configures environments | Define local, staging, and production explicitly. Use `flutter_flavorizr` for native flavors, typed Freezed configuration through Riverpod, and `--dart-define-from-file` for web. For Firebase, use Firebase CLI for login/Emulators and FlutterFire CLI for environment-specific generated options; do not transcribe Firebase options into JSON. Keep local demo configuration independent of cloud login. Separate service initialization from environment selection. Existing unrelated feature work does not require migrating every environment. Follow [references/environments-and-flavors.md](references/environments-and-flavors.md). | Native identifiers and schemes map to the same environment as Dart configuration; web builds without `--flavor`; non-production environment is visible in the UI; Firebase generation preserves local/native flavor setup; secrets are not embedded in client configuration. |
| An HTTP API with an OpenAPI document | The client comes from the `dart-dio` generator with its default `built_value` serialization, and calls are made through that generated client. Switch serializers only for a written project requirement; an option listed in the generator documentation is not a reason. Never rewrite generated files, including the generated `pubspec.yaml`, by hand or from a script. Fix resolution problems through generator configuration or version choice, or report them. Generation is pinned and documented, and the generated package is analyzed and tested on its own. The package's `test/` directory is hand-owned. Disable the generator's TODO stubs with `--global-property apiTests=false,modelTests=false`, or add `test/**` to `.openapi-generator-ignore`. Put real serializer and contract tests there, covering every nullable or optional field as omitted, `null`, and populated in responses, and as explicit `null` and populated in requests. The regeneration script reproduces the committed output from a clean checkout. Run `dart pub get` in the generated package before any formatting, whether the formatting is a separate step or `DART_POST_PROCESS_FILE`. `dart format` picks its style from the language version in `.dart_tool/package_config.json`, so formatting without it changes the output. | After committing or staging the output, the regeneration script is run in a clean copy without `.dart_tool` or `build`, and its package is compared with the delivered one using `git diff --exit-code` or `diff -r`. A rerun inside the working tree does not prove clean-checkout reproducibility. The exact commands and their result appear in the package README and the final summary. In a clean copy of the generated package, plain `dart pub get`, `dart run build_runner build`, and `dart analyze` succeed without flags or interactive prompts, and `dart analyze` exits 0. Silence generator-only diagnostics rule by rule in a package-local `analysis_options.yaml` listed in `.openapi-generator-ignore`, never with flags such as `--no-fatal-warnings`. `packages/<api>/test/` contains no generator TODO stubs, and `dart test` there runs the hand-written serializer tests. Those tests survive the second generator run. |

Host constraints sometimes require a plain `MaterialApp` or a transport-shaped interface. In that case, keep the constraint at the host boundary and still apply the convention inside it. For example, `EvalApp` can wrap a `MaterialApp.router`, and a gateway returning maps can sit behind a data-layer repository.

## Workflow

1. Inspect the app structure, SDK constraints, dependencies, code generation, API specifications, localization resources, theme, routes, and test setup.
2. Write a short compliance map before editing. List each checklist row the task triggers, and for each one the file where it will be satisfied. Read only the references for those rows.
3. Implement or adapt domain models, repositories, API adapters, providers/notifiers, typed routes, localization resources, and UI with the boundaries above.
4. Run the applicable generation, analysis, and tests.
5. Recheck every triggered row against its evidence column, using searches such as `grep` over the touched files. For the Freezed row, run `grep -n '^class ' <touched hand-written files>` and confirm that every public data class it finds is `@freezed`. Fix any miss before finishing. Do not report success while a triggered row still fails.
6. Summarize the generated artifacts, the validation results, and each triggered row with the file that satisfies it or the stated exception.

Before introducing or upgrading generators, verify that the pinned SDK, runtime packages, and generator packages are mutually compatible. Resolve dependencies and run a minimal clean code-generation build before implementing multiple features; do not assume a generated provider API from examples for another Riverpod major version. If the compatible generator has a defect or migration gap, keep affected providers hand-written with the project's supported `Provider`/`NotifierProvider` APIs rather than committing broken output, and record the exception and upgrade path.

## Read focused guidance

The checklist above is usually enough to decide what to build. Open a reference only for a concern in your compliance map that needs detail.

- For architecture or project structure decisions, read [references/architecture.md](references/architecture.md).
- For providers, state lifecycles, and Freezed models, read [references/riverpod-and-models.md](references/riverpod-and-models.md).
- When integrating an HTTP API, read [references/api-client.md](references/api-client.md).
- For themes, localization, accessibility, responsive UI, or navigation, read [references/ui-localization-and-navigation.md](references/ui-localization-and-navigation.md).
- For code generation, CI checks, or tests, read [references/testing-and-generation.md](references/testing-and-generation.md).
- Use [examples/reading_shelf/README.md](examples/reading_shelf/README.md) as a runnable reference when useful; it demonstrates the conventions without replacing project-specific requirements.

## Use Flutter's other agent skills when relevant

Consult the [Flutter agent-plugins skills catalog](https://github.com/flutter/agent-plugins/tree/main/skills) and use a matching skill if it is available in the current environment. Do not copy its contents into this skill. Common matches include:

| Work | Flutter skill |
| --- | --- |
| Architecture baseline | `flutter-apply-architecture-best-practices` |
| Localization setup | `flutter-setup-localization` |
| Declarative routing | `flutter-setup-declarative-routing` |
| Responsive layouts | `flutter-build-responsive-layout` |
| Layout debugging | `flutter-fix-layout-issues` |
| Widget tests | `flutter-add-widget-test` |
| Integration tests | `flutter-add-integration-test` |
| Static analysis | `dart-run-static-analysis` |
| Test mock generation | `dart-generate-test-mocks` |

Do not use `flutter-use-http-package` for API work covered by the Dio requirement. Use `flutter-implement-json-serialization` only where hand-authored serialization is needed; it does not replace Freezed models or OpenAPI-generated DTOs. If an external skill cannot be loaded, proceed with this skill and official Flutter documentation.

When instructions conflict, follow explicit project requirements first, then the mandatory conventions in this skill, then supplemental external skills.
