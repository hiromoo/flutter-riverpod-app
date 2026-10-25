# Flutter Riverpod Skill — Series 2, Iteration 3

Run three times on 2026-10-25 with Codex CLI 0.164.0 and Flutter 3.47.8
(`v2-it3-run1` to `v2-it3-run3`). The skill under test is commit `fb7e302`.
It keeps the [iteration 2](v2-iteration-2.md) environment guidance and adds
that a fixed host widget constructed without an outer `ProviderScope` owns its
scope. The rubric, fixtures, contract tests and harness are unchanged from
[iteration 1](v2-iteration-1.md) after its correction.

Run 2 hit the Codex usage limit partway through. The limited solver and
grader calls, and the run-3 preflight, were archived as numbered attempts
and resumed after the limit reset. No ordinary failure was retried. This is
exploratory evidence, not a statistical claim.

## Results

| Run | Condition | Functional | Conventions | Mechanical | Solver time | Solver tokens |
|---|---|---:|---:|---:|---:|---:|
| 1 | Without skill | 8/14 | 1/15 | 3/4 | 353.2 s | 1.44 M |
| 1 | With skill | 13/14 | 15/15 | 3/4 | 556.3 s | 3.28 M |
| 2 | Without skill | 9/14 | 1/15 | 3/4 | 319.3 s | 1.98 M |
| 2 | With skill | 14/14 | 13/15 | 4/4 | 1,521.9 s | 4.88 M |
| 3 | Without skill | 9/14 | 1/15 | 2/4 | 287.1 s | 2.04 M |
| 3 | With skill | 12/14 | 12/15 | 3/4 | 644.0 s | 4.17 M |
| **Total** | **Without skill** | **26/42** | **3/45** | **8/12** | **959.6 s** | **5.47 M** |
| **Total** | **With skill** | **39/42** | **40/45** | **10/12** | **2,722.2 s** | **12.33 M** |

Mechanical is the number of cases whose checks all passed. Token counts
include cached input and should not be read as billing amounts.

Three-run totals with the skill, compared with iteration 1:

| Case | Functional it1 → it3 | Conventions it1 → it3 | All mechanical it1 → it3 |
|---|---:|---:|---:|
| feature | 6/6 → 6/6 | 15/15 → 15/15 | 3/3 → 3/3 |
| api | 15/15 → 15/15 | 5/6 → 6/6 | 3/3 → 3/3 |
| refactor | 6/6 → 4/6 | 12/12 → 12/12 | 3/3 → 1/3 |
| environment | 8/15 → 14/15 | 9/12 → 7/12 | 2/3 → 3/3 |
| **Total** | **35/42 → 39/42** | **41/45 → 40/45** | **11/12 → 10/12** |

## Findings

- **Environment behavior is fixed.** Skill-assisted environment runs passed
  every mechanical check in all three runs, and functional assertions rose
  from 8/15 to 14/15. `selection` and `validation_docs` passed in every run
  except one `selection` miss: run 3 did not check the native flavor against
  `APP_ENV`. The host-widget regression from iteration 2 did not recur.
- **Environment conventions slipped.**
  - `config_model` failed in runs 2 and 3. To keep `EvalApp` working on its
    own, both resolved the config again in `EvalApp.build` instead of using
    the value from `main()`. Run 3 also left its provider unconnected.
  - `launch_config` failed in runs 2 and 3: no `.vscode/launch.json` was
    created. It passed in every iteration-1 run, so the longer guidance may
    have pushed it out.
  - `flavor_tooling` failed in run 3 because `flutter_flavorizr` was declared
    as `^2.4.1` instead of an exact version.
- **Refactor: the solver's own tests failed.** In runs 1 and 3, a test the
  solver added for Japanese retry, or retry after editing the query, failed in
  `all_tests`. The withheld contract and race tests passed, and the grader
  failed `incremental` on that evidence. The refactor guidance did not change
  in this iteration. Treat this as variation unless it recurs.
- **Cost.** With the skill, the solver used about 2.8 times the baseline's time
  and 2.3 times its tokens. Run 2 accounts for most of the time, spread
  across the API (532 s), environment (462 s) and refactor (406 s) cases.

## Improvement candidates

- Show the host-widget pattern concretely: the widget receives the resolved
  `AppConfig` from `main()` and keeps an overridden `ProviderScope` once per
  instance, not by resolving again in `build`.
- Make the VS Code launch entries an explicit, checkable deliverable in the
  checklist row, and require an exact `flutter_flavorizr` version.
- If the refactor misses recur, require running the added widget tests in
  both locales before finishing.
