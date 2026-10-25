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
