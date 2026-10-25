# Riverpod State and Models

Use Riverpod for state shared across widgets, business/application state, asynchronous data, and state that must outlive a widget. Use Freezed for immutable domain models and app-owned state models. The OpenAPI generator owns its generated transport DTOs; do not edit or wrap those DTO declarations in Freezed.

## Provider and notifier choices

- Prefer `Notifier` for synchronous state with user-driven mutations and `AsyncNotifier` for state whose initial value or refresh is asynchronous.
- Use `Provider`, `FutureProvider`, or `StreamProvider` for derived, read-only, or naturally asynchronous values that do not need command methods.
- Use `riverpod_annotation` and `riverpod_generator` for provider declarations in new code. Follow the project's pinned Riverpod API version and generated part-file conventions.
- Keep the Riverpod runtime and generator on compatible releases. After selecting versions, resolve dependencies and generate a minimal `@riverpod` provider before writing feature providers; compile the result against the resolved runtime. If generated APIs are incompatible or a known generator issue blocks a provider kind, prefer a normal supported provider declaration over hand-fixing `.g.dart` output, and leave a concise issue/upgrade note.
- Treat `StateNotifier` and `ChangeNotifier` as compatibility choices for existing integrations, not defaults for new feature state.
- A separate ViewModel is not required. Introduce a distinct coordinator only when it improves reuse, testability, or separation of responsibilities beyond the notifier.

## State ownership

- Keep temporary widget concerns such as `TextEditingController`, `FocusNode`, `AnimationController`, `TabController`, and ephemeral presentation selections in `flutter_hooks`. Do not use a hand-written `StatefulWidget`/`State` field as the default for local mutable state.
- When a widget needs both Riverpod and hooks, use `hooks_riverpod` and `HookConsumerWidget`; otherwise use `HookWidget`. Keep each hook's lifetime aligned with the widget that owns the UI concern.
- Keep shared, domain-relevant, persisted, or asynchronous feature state in Riverpod.
- Do not mirror the same mutable state in a hook and a provider. Keep one source of truth and derive other values.
- Widget code should use `ref.watch` for values rendered by the widget and `ref.read` to dispatch a command from callbacks. Use `select` or smaller widgets when a broad state dependency causes unnecessary rebuilds.
- Use provider families for parameterized resources and choose auto-dispose/lifetime behavior deliberately. Long-lived providers should represent intentionally shared app state, not be the accidental default for screen-scoped data.
- Register cleanup for subscriptions, timers, controllers, and other resources with the relevant provider or hook lifecycle. Guard asynchronous work against stale parameters and disposal. In notifiers, check `ref.mounted` after each `await` before assigning `state` or using `ref`. Test completion after dispose alongside out-of-order completion.

## Async and error state

- Represent loading, data, and failure with `AsyncValue` unless the UI has a concrete need for a richer Freezed state machine.
- Render loading, empty, success, and error/retry states explicitly. Do not silently convert failures to empty data.
- Retry resends exactly the parameters of the failed request. With a provider family, invalidate the family key that failed. Resubmitting the same parameters must also start a new request, so invalidate or refresh the key rather than only reassigning it. Give every error state, including detail screens, a retry action. With a single notifier, store the failed parameters and have `retry()` resend them. Do not rebuild them from widget input, which the user may have edited since the failure.
- Riverpod 3 retries providers that throw an `Exception` automatically (from 200 ms, doubling up to 6.4 s, ten times). `Error`s are not retried. While it retries, the UI shows loading instead of the error and its retry action. When the UI owns retry, pass `retry: (_, _) => null` to the root `ProviderScope`, to any scope a host widget creates, and to test `ProviderContainer`s. Put automatic retries that the product needs in the repository's transport policy instead.
- Keep exceptions and domain error values independent from localized UI strings. Map failures to safe presentation messages in the UI layer using `context.l`.
- Do not store `BuildContext`, widgets, or localized strings in providers, repositories, or domain objects.
- Keep command methods small and named by user intent. Ensure concurrent refreshes or submissions cannot produce stale state when that matters to the feature. Prefer a provider family keyed by the request parameters, which isolates each request. When a single notifier handles changing parameters, route the initial `build()` load and every command through one helper that applies the request id, error handling, and `ref.mounted` check. A separate unguarded initial-load path lets an old failure overwrite newer results.

## Freezed models

- Use Freezed for immutable domain entities, value objects, and complex app state where equality, copy/update semantics, or unions help.
- Prefer explicit fields and domain-oriented names. Keep JSON/API naming and nullability quirks out of domain types.
- Generated Freezed files are never edited by hand. Regenerate after changing annotations or part declarations.
- Any new hand-written model that crosses a layer, or is part of a public library API, uses Freezed, including small ones. A Dart record is acceptable only for a private tuple used within one file. Do not add a plain immutable class as a lighter alternative to Freezed.
- Task instructions take precedence for existing public types. When the task asks to keep a type's signature or names its consumers, leave the type unchanged and map to it at the boundary. Convert an existing plain data class only when the task allows changing it; then keep the published named parameters with a matching `const factory`.
