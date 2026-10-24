# Flutter Riverpod Skill — Series 2, Iteration 1

Run three times on 2026-10-24 and 2026-10-25 with Codex CLI 0.164.0 and Flutter 3.47.8
(`v2-run1` to `v2-run3`). In each run, GPT-6 Luna (`medium`) implemented
four tasks once with and once without the skill, and GPT-6 Astra (`high`)
graded them. The skill under test is commit `9c01756`, which adds the
environment and flavor conventions
([references/environments-and-flavors.md](../references/environments-and-flavors.md)).
The harness is commit `e39964b`, with one later fix to the contract test
(see [Harness corrections](#harness-corrections)).

Series 2 starts a new baseline. It adds an `environment` case and a `scope`
assertion to the feature and API cases, so its results are not comparable with
iterations 1–9. This is exploratory evidence, not a statistical claim.

## Results

| Run | Condition | Functional | Conventions | Mechanical | Solver time | Solver tokens |
|---|---|---:|---:|---:|---:|---:|
| 1 | Without skill | 9/14 | 1/15 | 1/4 | 971.7 s | 2.58 M |
| 1 | With skill | 12/14 | 13/15 | 4/4 | 997.4 s | 4.61 M |
| 2 | Without skill | 10/14 | 1/15 | 4/4 | 402.0 s | 1.65 M |
| 2 | With skill | 11/14 | 13/15 | 3/4 | 957.4 s | 4.89 M |
| 3 | Without skill | 9/14 | 1/15 | 2/4 | 342.1 s | 1.48 M |
| 3 | With skill | 12/14 | 15/15 | 4/4 | 1,335.4 s | 7.53 M |
| **Total** | **Without skill** | **28/42** | **3/45** | **7/12** | **1,715.9 s** | **5.71 M** |
| **Total** | **With skill** | **35/42** | **41/45** | **11/12** | **3,290.2 s** | **17.04 M** |

Mechanical is the number of cases whose checks all passed. Token counts
include cached input and should not be read as billing amounts. With the
skill, the solver used about 1.9 times the baseline's time and 3.0 times its
tokens.

Three-run totals by case:

| Case | Functional without → with | Conventions without → with | All mechanical checks passed |
|---|---:|---:|---:|
| feature | 6/6 → 6/6 | 0/15 → 15/15 | 2/3 → 3/3 |
| api | 11/15 → 15/15 | 3/6 → 5/6 | 2/3 → 3/3 |
| refactor | 6/6 → 6/6 | 0/12 → 12/12 | 2/3 → 3/3 |
| environment | 5/15 → 8/15 | 0/12 → 9/12 | 1/3 → 2/3 |

## Findings

- **Existing cases held.** Feature and refactor were fully compliant in every
  skill-assisted run. API missed one convention in run 1: the hand-written
  `ReadingRecord` stayed a plain class instead of Freezed.
- **No over-application.** The new `scope` assertion passed in every
  feature and API run with the skill, so the environment conventions were not
  carried into tasks that do not configure environments.
- **The environment conventions mostly transferred.** With the skill, all
  three runs used `flutter_flavorizr` and a Freezed `AppConfig` exposed
  through Riverpod, and added per-environment VS Code launch entries. None of
  the baseline runs did any of these. The baseline edited the native flavor
  configuration by hand, and in run 3 it added no iOS schemes. One baseline run localized the indicator as 「ローカル」,
  which `TASK_ENV.md` does not allow.
- **Two environment assertions failed in every skill-assisted run.**
  - `selection`: every run fell back to `local` when `APP_ENV` was missing,
    and resolved the configuration inside `EvalApp` instead of before
    `runApp`. The rubric is stricter than its sources here. The reference
    rejects unknown and empty required values and forbids inferring
    production, but does not require rejecting a missing `APP_ENV`. The host
    interface requires `EvalApp` to reflect the environment by itself, which
    pushes resolution into the widget. Read this result with that in mind.
  - `validation_docs`: tests covered parsing, invalid values and flavor
    mismatch, but the documentation lacked a complete set of per-environment
    build commands (native builds, or some web run/build combinations).
- **Defect: non-const `String.fromEnvironment`.** In run 2, the skill-assisted
  solution read `APP_ENV` with a non-const `String.fromEnvironment` call. It
  therefore ignored the define file, and the staging and production contract
  tests failed. The reference does not yet say that compile-time values must
  be read in a const context.
- **`context.l` was skipped in the environment banner.** Runs 1 and 2 used
  `AppLocalizations.of(context)` directly inside the banner widget. This is
  the only `banner_l10n` miss.

## Improvement candidates

- State in the reference that `String.fromEnvironment` must be read in a
  `const` context, and add a test that fails when it is not.
- Ask for a single table of per-environment run and build commands for web,
  Android and iOS.
- For the next series, make the `selection` assertion match the reference
  (missing `APP_ENV` either rejected or explicitly documented as `local`), or
  extend the reference first. Do not change it within this series.

## Harness corrections

- **Skill isolation (before any model call).** The first attempt stopped at
  the isolation preflight. Codex discovered `SKILL.md` files nested inside the
  symlinked skill directory (`eval-results/*/skill-snapshot/`), which the
  disable list did not cover. Commit `e39964b` disables nested skills too. The
  attempt is kept under `eval-results/setup-failure-2/`.
- **Environment contract test.** `all_tests` runs the withheld contract test
  without defines. Its indicator checks then expected no banner and failed
  every implementation that defaults to `local`. This caused the `all_tests`
  failures in the run-1 and run-2 skill-assisted environment runs, and the
  grader cited them. The indicator checks are now skipped when `APP_ENV` is
  empty. For all three runs, the six environment outputs were re-verified and
  re-graded without changing solver outputs. The previous artifacts are in
  `downstream-attempt-1/`. Each `manifest.json` records the correction and
  both hashes under `corrections`.
- **Usage limit.** Three of the re-grading calls hit the Codex usage limit.
  They were archived as `judge-attempt-1/` and resumed after the limit reset.

Each pair still needs human review; no agent-generated review is recorded as
human approval.
