# Flutter Riverpod Skill — Series 2, Iteration 4

Run once on 2026-10-25 with Codex CLI 0.164.0 and Flutter 3.47.8
(`v2-it4-run1`). The skill under test is commit `ade0c67`. The rubric,
fixtures, contract tests and harness are unchanged from
[iteration 1](v2-iteration-1.md) after its correction. This is a single run:
read differences from [iteration 3](v2-iteration-3.md), which had three
runs, as indications only.

Changes since iteration 3:

- **Riverpod automatic retry.** Riverpod 3 retries a provider that throws an
  `Exception`, starting after 200 ms. During the retry the UI is back in
  loading, so the error state and its retry action disappear. This caused
  the iteration-3 refactor test failures. The withheld contract test fails
  with a `StateError`, which is not retried, so it did not catch this. The
  skill now passes `retry: (_, _) => null` to every scope and test
  container, and failure tests throw an `Exception` and pump past 200 ms.
  The Reading Shelf example does the same.
- **Host widget pattern.** A code example shows a host widget that resolves
  its config once per instance and owns its `ProviderScope`.
- **Checkable deliverables.** `.vscode/launch.json` entries and an exact
  `flutter_flavorizr` version are now in the checklist row.

## Results

| Condition | Functional | Conventions | Mechanical | Solver time | Solver tokens |
|---|---:|---:|---:|---:|---:|
| Without skill | 8/14 | 1/15 | 2/4 | 354.2 s | 1.55 M |
| With skill | 14/14 | 12/15 | 4/4 | 717.3 s | 7.19 M |

| Case, with skill | Functional | Conventions | Mechanical | Iteration-3 average (F / C) |
|---|---:|---:|---:|---:|
| feature | 2/2 | 5/5 | 8/8 | 2.0 / 5.0 |
| api | 5/5 | 1/2 | 14/14 | 5.0 / 2.0 |
| refactor | 2/2 | 3/4 | 8/8 | 1.3 / 4.0 |
| environment | 5/5 | 3/4 | 15/15 | 4.7 / 2.3 |

## Findings

- **The retry fix took effect.** Every skill-assisted case that creates a
  `ProviderScope` (feature, refactor, environment) set
  `retry: (_, _) => null`. The refactor tests passed in `all_tests`, so
  `incremental` passed. It failed in two of three iteration-3 runs.
- **Environment conventions improved but `config_model` still failed.**
  `launch_config` and `flavor_tooling` passed. `config_model` failed because
  `main()` validated the config and discarded it, and `EvalApp` resolved it
  again. `TASK_ENV.md` fixes the `EvalApp` constructor, so the solver did not
  add the `config` parameter from the skill's example. This is a conflict
  between the fixture's host interface and the guidance, not only a model
  miss.
- **Recurring and new misses.**
  - API kept the hand-written `ReadingRecord` as a plain class. This is the
    third miss in series 2 (iteration 1 run 1, iteration 2, iteration 4).
  - Refactor branched on the language code with inline strings instead of
    ARB and `context.l` (`l10n`). It had passed in every earlier series-2
    run.
- **Cost.** Solver tokens with the skill (7.19 M) were higher than any
  iteration-3 run (3.28–4.88 M). With one run, this cannot be separated from
  variation.

## Improvement candidates

- Allow an optional `config` parameter in the environment fixture's host
  interface in the next series, or say in the guidance what to do when the
  host constructor is fixed (for example, resolve once in a static field).
  The guidance option is applied after this run: the reference now resolves
  the config once in a top-level `final` when the host constructor is fixed.
  It has not been evaluated yet.
- Look at why the Freezed trigger for pre-existing plain classes still misses
  about one run in three.
