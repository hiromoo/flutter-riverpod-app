# Skill evaluation

This benchmark measures how `flutter-riverpod-skill` changes **GPT-6 Luna's implementation output** on four existing-app tasks. It does not measure skill discovery, new-project setup, other solver models, or superiority over other skill repositories.

## Fixed profile

| Role | Model | Reasoning |
|---|---|---|
| Solver, both conditions | `gpt-6-luna` | `medium` |
| Rubric grader | `gpt-6-astra` | `high` |

Four cases (feature, OpenAPI integration, incremental refactor, environment flavors), with and without the skill: eight solver runs and eight grading runs per repetition. Availability/isolation preflights are additional short calls. Run each role sequentially, with a 30-minute deadline per solver/grader call. Timeouts and failures are retained. A single run per condition is exploratory evidence, not a statistical reliability claim.

The case prompts, expected outputs, and rubric are in [`evals/evals.json`](evals/evals.json). The independent contract tests are in `evals/checks/`. These are frozen before execution. Functional criteria and skill-convention criteria are reported separately; convention compliance cannot compensate for broken behavior.

## Requirements and commands

- Python 3.10+, authenticated Codex CLI with `gpt-6-luna` and `gpt-6-astra` access.
- Flutter **3.47.8**, including its bundled Dart. The default version is read from `evals/fixtures/common/.fvmrc` and resolved under `~/fvm/versions/`; override with `--sdk /absolute/flutter/sdk`. Historical benchmark reports retain the SDK used for those runs.
- Cached fixture dependencies (`flutter pub get --offline --enforce-lockfile` is run before each task).
- Java 17+, Node/npm and access to OpenAPI Generator **7.25.0** for the API task. Generator wrapper/version is supplied in the fixture.
- Ruby with the `xcodeproj` gem for the environment task, which `flutter_flavorizr` uses to create iOS schemes. Native builds are not run; Android/iOS flavors are checked statically and web is built once per environment.
- Permission for the CLI to contact the model service and for Flutter/Dart to write SDK/package caches. Run from an ordinary terminal if an enclosing sandbox prevents this; the child agents still use their own workspace-write/read-only sandboxes. No sandbox-bypass flag is used.

```sh
# No model calls or repo mutations:
python3 scripts/run_evals.py validate
python3 scripts/run_evals.py dry-run
python3 -m unittest discover -s evals/tests -v

# Explicit model calls: eight implementations, verification, then grading per run:
python3 scripts/run_evals.py run

# A case can be selected. Completed and ordinary failed records are not overwritten.
# Usage-limit failures alone are archived as numbered attempts and resumed:
python3 scripts/run_evals.py run --case api

# Rebuild summaries without model calls:
python3 scripts/run_evals.py aggregate
```

Use a new `--output` directory for a fresh iteration. Changed fixtures, prompts, rubrics or tests are rejected against the original iteration manifest. Do not delete failed run records to obtain a better score. Record any harness correction and revalidation separately. The `verify` and `judge` actions complete missing verification/grading artifacts without regenerating outputs; a recorded attempt is retained rather than silently retried.

## Isolation and evidence

Each solver receives a fresh temporary project outside the source repository. Both conditions get byte-identical fixtures, SDK and initial lockfile. Only the skill condition receives an explicit path to a snapshot of `SKILL.md`, references and the tracked runnable example. This evaluates the supplied skill bundle, including optional example use and linked guidance, not `SKILL.md` text in isolation.

The runner ignores personal CLI config, disables plugins/apps/memory/delegation/hooks, disables host skill discovery and explicitly disables the installed standard skills. `project_doc_max_bytes=0` prevents inherited AGENTS.md instructions. Both model roles must report an empty initial skill catalog in preflight. Codex can re-extract its system skills when a process starts, after the runner has built its disable list. The runner therefore compares the skill set on disk before and after every Codex call and records `skill_set_changed`. A preflight whose skill set changed is kept with a `-stale` suffix and retried once. It fails if the set changes again. This is context isolation, not a filesystem confidentiality boundary: transcripts should also be reviewed for unexpected reads outside the allowed project, installed SDK/packages, and explicitly supplied skill. The authentication home is never copied or changed.

Independent contract tests are withheld from the solver and installed only in a separate verification copy. Verification runs dependency resolution, generation, analysis and tests. API output is additionally checked as a standalone Dart package. The API task requires a `tool/generate_api.sh` entry point, which the verifier runs on another clean copy of the output. It then compares the regenerated `packages/reading_api` with the delivered package, ignoring `.dart_tool`, `build` and `pubspec.lock`. The results are recorded as `api_regeneration` and `api_regeneration_diff` in `verification.json` and `checks/`. A missing entry point, a failed run or any difference is a mechanical failure. The environment task runs its contract test and `flutter build web` with each `config/<environment>.json`, without `--flavor`. The regeneration check was added after iteration 3. Earlier iterations had no independent regeneration evidence, so their regeneration assertion is not comparable with later ones. The verifier does not repair implementation errors. It preserves source artifacts, so regenerated validation output cannot replace the original result.

The grader receives a neutral directory with the output, fixed rubric and compiler/test evidence, but not the condition label, solver identity, or solver's completion claims. Output content can still reveal conventions; this is label masking, not guaranteed perfect blinding. The grader must cite files/lines or logs for each result. Mechanical results are independent and cannot be overridden by the grader.

## Results and interpretation

Series 2 starts with the environment case and the `scope` assertions on the feature and API cases. Its results (`eval-results/v2-*`, `benchmarks/v2-*.md`) are not comparable with iterations 1–9, which used three cases, a different rubric and Flutter 3.47.5. Codex usage limits are treated as resumable: a solver, grader or preflight call that failed only because of the limit is archived as a numbered attempt and rerun by the same `run` command.

Local raw artifacts live under `eval-results/iteration-N/` (gitignored):

- `manifest.json`, `skill-snapshot/`, `skill-hashes.json`: exact profile, input hashes, CLI/SDK versions and guidance.
- `<case>/<condition>/outputs/`, `changes.diff`, `prompt.txt`, `transcript.jsonl`, `response.md`: implementation evidence.
- `solve.json`, `judge.json`: status, time, configuration and measured token usage for each role.
- `checks/`, `verification.json`, `grading.json`, `judge-transcript.jsonl`: independent validation and evidence-backed grading.
- `benchmark.json`, `summary.md`: aggregated results. Missing/blocked checks are not successes. Cached input and reasoning-token subsets are not double-counted.

Raw artifacts remain available locally; summaries intended for version control go under `benchmarks/`. Do not commit credentials, caches or model authentication data. Each first-iteration pair should receive human review; an agent-generated review is not recorded as human approval. Improvement candidates should generalize beyond the fixtures. Skill changes and repeated-trial evaluation are follow-up work.

## Sources

- [Agent Skills: evaluating skill output quality](https://github.com/agentskills/agentskills/blob/main/docs/skill-creation/evaluating-skills.mdx): paired runs, assertions, evidence and iteration.
- [flutter-skills public benchmark](https://github.com/thiennc-tesoglobal/flutter-skills/blob/main/benchmarks/README.md): preserved failures, compiler-backed checks and explicit paid execution.
- [Codex non-interactive mode](https://developers.openai.com/codex/noninteractive): CLI execution and structured events.

The external repositories inform the methodology; their skill content and benchmark scores are not copied or used as a direct competitor baseline.
