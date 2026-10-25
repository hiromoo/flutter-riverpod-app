# Flutter Riverpod Skill — Series 2, Iteration 2

Run once on 2026-10-25 with Codex CLI 0.164.0 and Flutter 3.47.8
(`v2-it2-run1`). The skill under test is commit `a45c354`, which applies the
improvement candidates from [iteration 1](v2-iteration-1.md) to the
environment guidance. The rubric, fixtures, contract tests and harness are
unchanged from iteration 1 after its correction.

The planned second and third runs were stopped: run 1 showed a regression
caused by the new guidance. The interrupted second run is kept under
`eval-results/aborted-v2-it2-run2/` and is not counted. This is exploratory
evidence from a single run.

## Results

| Condition | Functional | Conventions | Mechanical | Solver time | Solver tokens |
|---|---:|---:|---:|---:|---:|
| Without skill | 9/14 | 1/15 | 2/4 | 340.9 s | 1.89 M |
| With skill | 13/14 | 13/15 | 3/4 | 953.6 s | 5.71 M |

| Case, with skill | Functional | Conventions | Mechanical |
|---|---:|---:|---:|
| feature | 2/2 | 5/5 | 8/8 |
| api | 5/5 | 1/2 | 14/14 |
| refactor | 2/2 | 3/4 | 9/9 |
| environment | 4/5 | 4/4 | 12/15 |

## Findings

- **The targeted environment assertions passed.** `selection`,
  `validation_docs`, `config_model` and `banner_l10n` passed in the
  skill-assisted run. All four had failed in at least one iteration-1 run.
- **Regression: the host widget lost its `ProviderScope`.** Following the
  new instruction to resolve the config in `main()` and override the
  provider there, the solution moved `ProviderScope` into `main()`. The
  host-constructed `EvalApp` then threw `No ProviderScope found`, and the
  contract tests failed for all three environments (`indicator`). The
  guidance did not say that a fixed host widget must keep working without an
  outer scope.
- **Unrelated misses.** API kept the hand-written `ReadingRecord` as a plain
  class instead of Freezed, as in iteration 1 run 1. Refactor left the search
  `TextField` without a hook-managed controller (`local_state`). Neither
  guidance changed in this iteration, so these are run-to-run variation.

## Change for iteration 3

The reference now states that a fixed host widget constructed without an
outer `ProviderScope` owns its scope, overrides the config provider with the
value from `main()` or falls back to the same const factory, and must never
depend on a scope that only `main()` creates. It also asks for one widget test
that pumps the root widget exactly as the host does.
