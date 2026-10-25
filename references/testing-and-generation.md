# Code Generation, Validation, and Tests

Use relevant Flutter agent skills when available: `dart-run-static-analysis`, `dart-generate-test-mocks`, `flutter-add-widget-test`, and `flutter-add-integration-test`. Read only guidance needed for the current change. Follow the target repository's existing scripts and CI conventions.

## Generated code

- For new Flutter apps, pin an exact, verified Flutter release in `.fvmrc`; use FVM's Flutter and Dart proxy commands locally and configure CI to read that same file. Keep `.fvm/` caches and SDK symlinks out of version control. Existing projects may retain another established version manager.
- When a repository contains multiple Dart/Flutter packages, run each package's analyzer and tests from that package's own context. Scope app analysis to app source and tests (for example `flutter analyze lib test`) so nested server or tooling packages are not analyzed against the app's package configuration.

- Never edit generated files by hand. Edit source annotations, ARB files, OpenAPI documents, or generator configuration, then run the owning generator.
- Keep generation commands and tool versions reproducible. Avoid unrelated generated diffs; review generated output whenever a schema or route change affects public app behavior.
- At project setup or after dependency upgrades, first resolve dependencies and run a minimal clean build for every generator (Riverpod/Freezed/router, built_value, and l10n as applicable). Check generated files compile against the resolved runtime packages before scaling out implementation; generator package version, runtime package version, Dart SDK, and analyzer constraints must be compatible. Avoid fixing generator/runtime mismatches by manually editing output. If needed, use supported handwritten provider declarations temporarily and document the reason.
- Generated output must be reproducible from a clean checkout. Resolve dependencies before any formatting step, because `dart format` depends on `.dart_tool/package_config.json`, and verify regeneration in a copy without `.dart_tool` and `build`.
- Treat generator cleanup/output directories as destructive boundaries: configure output paths narrowly and add local configuration, hand-maintained tests, and package metadata to the generator ignore list when the tool otherwise removes them. Re-run generation and verify those files remain present afterward.
- Typical generators include Riverpod/Freezed and `go_router_builder` via `build_runner`, OpenAPI Generator for Dio clients, and Flutter `gen-l10n` for ARB resources. Use the commands already defined by the app where present.
- Validate OpenAPI specifications before client generation. For new apps, commit generated API code and make CI detect changes after regeneration.
- When generated code lives in `packages/api_client`, run generation with that package as the output target, then run its own dependency resolution, any serializer generation required by its generated sources (including `built_value` serializers when present), and Dart analysis. Validate both the package and the consuming app; app-root checks alone do not establish that the generated package builds.
- Run `dart test`/`dart analyze` from the generated package directory (or invoke its package-specific scripts). A passing `dart test` over generator TODO stubs is not validation. Ignore `test/**` in the generator and put the hand-written serializer tests in the package. A successful app-root analysis does not validate a path dependency as an independent package. Keep known generator-only lint suppressions package-local and narrowly scoped; never silence project-wide diagnostics to accommodate generated code. Put them in the package's `analysis_options.yaml`, protect that file from generator cleanup, and require plain `dart analyze` to exit 0 rather than relaxing it with flags.
- For OpenAPI `built_value` clients, explicitly test nullable/optional fields both ways: decode responses where an optional nullable property is absent or null, map it into domain nullability safely, then serialize requests/round trips. Generated `Optional<T>` values may distinguish absent from present-null, and `value` access on an absent wrapper can throw. Do not assume null-valued response keys are emitted by the built_value standard JSON plugin.
- Keep the API package's generation and validation commands in its own README or package scripts so contributors and CI invoke the same sequence. Avoid rerunning unrelated application generators from inside the API package.
- Ensure all supported ARB files contain compatible keys and placeholder definitions. Run `flutter gen-l10n` and treat generation failures as localization contract failures.

## Proportionate validation

After implementation, choose checks based on the changed surface. Common checks are:

1. Format the changed Dart sources using the repository's formatter command.
2. Run applicable code generation and localization generation.
3. Run `flutter analyze` or the repository's static analysis script.
4. Run targeted tests, then broader relevant tests when the change crosses feature boundaries.
5. For API changes, validate the OpenAPI document and verify generated output is reproducible.

Do not claim a check passed unless it was run. If a required check cannot run, report the concrete blocker and checks that did run.

## Test boundaries

- Repository and data adapter tests cover mapping, caching or persistence behavior, transport failures, and observable contracts. Fake services or mock generated clients at the adapter seam where practical.
- Notifier tests cover initial, loading, success, error, refresh/retry, user commands, and provider lifecycle behavior. For overlapping requests, include one that starts while the initial load is pending and check both completion orders. For retry, change the input after a failure and assert that the failed parameters are requested again. Fail with an `Exception` (as a real transport does), not only an `Error`, and pump past 200 ms before expecting the error state, so that Riverpod's automatic retry would be caught. Use provider overrides for dependencies rather than global mutable test state.
- Widget tests cover rendering, interactions, accessibility-relevant semantics, localized content, and theme behavior. Prefer focused tests that assert observable behavior.
- Router tests cover typed path/query parameters, redirects, error routes, deep links, and shell navigation where used.
- Integration tests cover only high-value end-to-end flows that cross real app boundaries; keep unit and widget tests as the faster default feedback loop.
- For localized UI, exercise English and Japanese, parameterized messages, pluralization where present, long strings, and locale changes. Include RTL only when a supported locale requires it.
- For themed UI, verify light and dark schemes and ensure components read from the active theme.
- API tests should cover success and representative failures such as authentication, validation, timeout, offline transport, malformed payload, and unknown enum values when relevant to the contract.
