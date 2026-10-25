# Flutter Riverpod Skill — Series 3, Iteration 1

Run once on 2026-10-25 with Codex CLI 0.164.0 and Flutter 3.47.8
(`v3-run1`). The skill under test and the harness are commit `760bd90`.
GPT-6 Luna (`medium`) implemented the four tasks with and without the skill,
and GPT-6 Astra (`high`) graded them. This is a single exploratory run, not a
statistical claim.

## Why a new series

A series-2 iteration 5 run (`v2-it5-run1`, environment case only, skill
commit `fc09f41`) showed that the skill-assisted iOS flavors could not
build. `flutter_flavorizr`'s `ios:buildTargets` sets each configuration's
app icon to `AppIcon-$(ASSET_PREFIX)`, but no `AppIcon-<env>` icon sets were
created. All nine series-2 skill-assisted environment outputs had this
defect. Series 2 checked native flavors only statically, so it was not
detected. Android debug builds of the same output succeeded.

Series 3 changes:

- **Verification** builds a debug APK and an iOS simulator app for every
  flavor in the environment case, in addition to the web builds.
- **Fixture.** `EvalApp` may take optional named parameters, so a config
  resolved in `main()` can be passed in. Series 2 fixed the constructor,
  which conflicted with resolving the config once (`config_model`).
  `TASK_ENV.md` also states that each flavor must build natively.
- **Skill.** The reference requires an `AppIcon-<env>` icon set per iOS
  flavor and native flavor builds where toolchains exist.

The environment results are not comparable with series 2. The other three
cases are unchanged.

## Results

| Condition | Functional | Conventions | Mechanical | Solver time | Solver tokens |
|---|---:|---:|---:|---:|---:|
| Without skill | 10/14 | 1/15 | 2/4 | 360.3 s | 1.66 M |
| With skill | 14/14 | 14/15 | 4/4 | 779.9 s | 4.45 M |

| Case | Functional without → with | Conventions without → with | Mechanical without → with |
|---|---:|---:|---:|
| feature | 2/2 → 2/2 | 0/5 → 5/5 | 7/7 → 8/8 |
| api | 5/5 → 5/5 | 1/2 → 1/2 | 14/14 → 14/14 |
| refactor | 2/2 → 2/2 | 0/4 → 4/4 | 6/8 → 9/9 |
| environment | 1/5 → 5/5 | 0/4 → 4/4 | 18/20 → 21/21 |

## Findings

- **The environment case passed completely with the skill.** All nine
  native and web builds passed. The output added `AppIcon-local`,
  `AppIcon-staging` and `AppIcon-production`, resolved the config once in
  `main()` and passed it to `EvalApp` through the new optional `config`
  parameter.
- **The baseline's native builds also passed.** Without the skill, the
  solver configured Android and iOS flavors by hand without icon-set
  indirection, so all six native builds passed. Its contract tests for local
  and staging failed, and it met none of the environment conventions.
- **The only miss with the skill was Freezed in the API case.** The
  hand-written `ReadingRecord` stayed a plain class. This is the fourth such
  miss since series 2 (series 2 iteration 1 run 1, iteration 2, iteration 4,
  and this run).
- **Cost.** The skill used about 2.2 times the baseline's solver time and 2.7
  times its tokens.

## Next

- Repeat this series before drawing conclusions from one run.
- Investigate the recurring Freezed miss for pre-existing plain classes in
  the API case.

## API rerun after the Freezed policy change

Commit `ad2cc1b` changed the skill so that task instructions win for
existing public types: `ReadingRecord`, whose signature the task preserves,
stays a plain class, and only new hand-written models must use Freezed. The
API `freezed` assertion was relaxed to match. The API case was then run once
more (`v3-run2`, API only).

| Condition | Functional | Conventions | Mechanical |
|---|---:|---:|---:|
| Without skill | 4/5 | 2/2 | 13/14 |
| With skill | 5/5 | 2/2 | 14/14 |

Both conditions kept `ReadingRecord` unchanged and added no new hand-written
model, so `freezed` passed in both and no longer separates them. The
remaining difference is `package_validation`: without the skill, the
generated package failed `dart analyze` on unused-import warnings. To measure
Freezed adoption again, a case needs to make the solver add a new domain
model.

## CI/CD case

Commit `49c3ad1` added the `ci` case: an app that already has the three
flavors gets GitHub Actions verification and delivery under `TASK_CI.md`.
It was run once on 2026-10-25 (`v3-ci-run1`, CI/CD only) with the skill at
the same commit, which includes `references/ci-and-delivery.md`.

| Condition | Functional | Conventions | Mechanical | Solver time | Solver tokens |
|---|---:|---:|---:|---:|---:|
| Without skill | 2/6 | 0/3 | 30/30 | 165.2 s | 0.86 M |
| With skill | 2/6 | 3/3 | 30/30 | 346.5 s | 0.87 M |

Both outputs passed every mechanical check: the static CI contract,
`actionlint`, release web and staging App Bundle builds without signing
secrets, tests, and the unchanged-file checks. Both passed `secrets` and
`scope`. With the skill, all three conventions passed (shared `.fvmrc`
setup, reusable per-environment delivery, hardening); without it, none did.

The skill-assisted functional misses came from the reference itself:

- **`verify_gate`.** The verify template tied `build_runner` and the
  generated-output diff to the API regeneration step. The app has no API
  package, so the solver dropped all three, leaving analysis and tests only.
- **`environment_mapping`.** `run_number * 10 + run_attempt` collides from
  the tenth attempt (run 1 attempt 11 and run 2 attempt 1 both give 21).
  GitHub allows up to 50 re-runs of a workflow run.
- **`triggers` and `docs`.** The iOS archive had no Apple team: the
  template relied on a team set in the Xcode project, and the docs did not
  say how to provide one.

The baseline missed the same `verify_gate` and build-number points, did not
upload production store builds, and checked out after downloading the web
artifact, which would delete it before the Hosting deploy.

The reference now keeps generation and the diff check in every verify
workflow, uses `run_number * 100 + run_attempt`, passes `APPLE_TEAM_ID` to
the archive and to a copy of `ExportOptions.plist`, and asks `docs/ci.md`
for a verification status (commit `7b7e27d`).

### Rerun after the reference fixes

The `ci` case was run once more with the skill at `7b7e27d`
(`v3-ci-run2`).

| Condition | Functional | Conventions | Mechanical | Solver time | Solver tokens |
|---|---:|---:|---:|---:|---:|
| Without skill | 2/6 | 0/3 | 30/30 | 158.0 s | 0.67 M |
| With skill | 6/6 | 2/3 | 30/30 | 196.8 s | 0.75 M |

With the skill, all four earlier functional misses passed: the verify
workflow regenerates code and fails on a generated-output diff, build
numbers use `run_number * 100 + run_attempt`, iOS signing takes
`APPLE_TEAM_ID`, and `docs/ci.md` states that signing, store uploads and
Hosting deploys are unverified.

The remaining miss was `hardening`, again from the reference: the staging
and production templates granted `checks: write` and `pull-requests: write`
at workflow level, so the verify, Android and iOS jobs inherited them. The
reference now keeps `contents: read` at workflow level and grants the write
permissions only on the job that calls the Hosting deploy (commit
`e16aab3`).

The baseline again missed the same four functional points and all three
conventions; it also wrote the upload keystore to a path that the Gradle
signing config resolves differently.

### Rerun after the permissions fix

The `ci` case was run a third time with the skill at `e16aab3`
(`v3-ci-run3`).

| Condition | Functional | Conventions | Mechanical | Solver time | Solver tokens |
|---|---:|---:|---:|---:|---:|
| Without skill | 2/6 | 0/3 | 30/30 | 317.0 s | 1.61 M |
| With skill | 5/6 | 3/3 | 30/30 | 181.6 s | 0.70 M |

`hardening` passed with the skill, so all three conventions passed again.

The one functional miss, `triggers`, appears to be a grading error. The
grader said the iOS upload cannot work because the flavor schemes in the
fixture have an empty `BuildAction`, so archiving them would build nothing.
The schemes are as `flutter_flavorizr` 2.6.0 generated them, and the
Reading Shelf sample has the same empty `BuildAction`. An unsigned archive
of the fixture's `staging` scheme succeeded locally (`flutter build ios
--config-only --release --flavor staging`, then `xcodebuild -scheme staging
-configuration Release-staging archive CODE_SIGNING_ALLOWED=NO`) and
produced `Runner.app`. The score is kept as graded; this evidence is
recorded beside it, not used to override it. Signed export was not tested.

The baseline missed the same four functional points as in the earlier runs
and all three conventions.

Across the three `ci` runs, the skill-assisted functional misses that came
from the reference were fixed one by one (verify steps, build numbers, iOS
team, documentation status, then job permissions). Each run is a single
exploratory run.

