# Flutter Riverpod Skill

An agent skill for Codex and Claude Code for designing and building Flutter applications with Riverpod. Use it when starting a new app, adding features, or incrementally refactoring an existing application.

[English](README.md) | [日本語](README.ja.md)

## Principles

- Use Flutter's official [Architecture Best Practices skill](https://github.com/flutter/agent-plugins/blob/main/skills/flutter-apply-architecture-best-practices/SKILL.md) as the architectural baseline, with additional guidance for Riverpod.
- Organize code by feature and use Riverpod `Notifier` / `AsyncNotifier`, Freezed, and `flutter_hooks`.
- Pin the verified Flutter SDK with FVM and `.fvmrc` for new Flutter projects.
- Separate local, staging, and production for new apps and environment configuration tasks. Use `flutter_flavorizr` for Android/iOS, compile-time configuration for web, and VS Code launch configurations.
- Generate API clients from OpenAPI specifications with OpenAPI Generator's `dart-dio` generator.
- Use a centralized UI theme, Flutter `gen_l10n` for localization, and type-safe `go_router` routes.
- Consult additional Flutter agent skills when they fit the task; do not duplicate their contents here.

## Usage

The skill instructions are in [SKILL.md](SKILL.md); focused guidance is available in [`references/`](references/). The same files work with both Codex and Claude Code.

### Codex

Clone this repository into a Codex skills directory, keeping `flutter-riverpod-skill` as the directory name:

```sh
# Available in all projects
git clone https://github.com/hiromoo/flutter-riverpod-skill.git ~/.agents/skills/flutter-riverpod-skill

# Or only in one repository (run from the repository root)
git clone https://github.com/hiromoo/flutter-riverpod-skill.git .agents/skills/flutter-riverpod-skill
```

If you already have a local clone, symlink it instead, for example `ln -s "$PWD" ~/.agents/skills/flutter-riverpod-skill`. Restart Codex if the skill does not appear. Codex uses the skill automatically for matching Flutter tasks; you can also invoke it explicitly by mentioning `$flutter-riverpod-skill` or selecting it from `/skills`.

### Claude Code

Clone this repository into a Claude Code skills directory, keeping `flutter-riverpod-skill` as the directory name:

```sh
# Available in all projects
git clone https://github.com/hiromoo/flutter-riverpod-skill.git ~/.claude/skills/flutter-riverpod-skill

# Or only in one project (run from the project root)
git clone https://github.com/hiromoo/flutter-riverpod-skill.git .claude/skills/flutter-riverpod-skill
```

If you already have a local clone, symlink it instead, for example `ln -s "$PWD" ~/.claude/skills/flutter-riverpod-skill`. Claude Code loads the skill automatically for matching Flutter tasks; you can also invoke it explicitly with `/flutter-riverpod-skill`.

## Sample app

[Reading Shelf](examples/reading_shelf/README.md) is an Android, iOS, and web reading tracker with a Shelf API. It demonstrates three environments, Firebase/Supabase initialization with Firebase CLI and environment-specific FlutterFire CLI output, a top-left environment banner, and VS Code launch configurations. Local development uses the Supabase CLI public key and Firebase Emulator configuration. Staging and production each require their cloud configuration and a running Shelf API.

## References

- [Flutter agent-plugins skills](https://github.com/flutter/agent-plugins/tree/main/skills)
- [Flutter architecture skill](https://github.com/flutter/agent-plugins/blob/main/skills/flutter-apply-architecture-best-practices/SKILL.md)
- [Flutter internationalization guide](https://docs.flutter.dev/ui/internationalization)
- [OpenAPI Generator `dart-dio`](https://openapi-generator.tech/docs/generators/dart-dio/)

## Repository structure

```text
SKILL.md
agents/openai.yaml   # Codex UI metadata (ignored by Claude Code)
references/
  architecture.md
  riverpod-and-models.md
  api-client.md
  ui-localization-and-navigation.md
  testing-and-generation.md
  environments-and-flavors.md
  ci-and-delivery.md
```

## License

This repository is released under the [MIT License](LICENSE).

## Evaluation

Reproducible implementation evaluations compare GPT-6 Luna with and without this skill, with GPT-6 Astra grading and independent Flutter/Dart checks. See [the evaluation guide](EVALUATION.md) for the fixed cases, commands, and limitations.

The [initial measured result](benchmarks/iteration-1.md) found higher functional and convention pass rates with the skill, while also showing substantial time/token overhead and several conventions that Luna still applied inconsistently. After adding a convention checklist, [iteration 2](benchmarks/iteration-2.md) raised the skill's convention pass rate from 27.3% to 81.8% with unchanged functional results, though one refactor run regressed on a disposal check. [Iteration 3](benchmarks/iteration-3.md) reached 11/11 on conventions and passed every mechanical check, but its functional pass rate fell to 4/7 because of retry and race defects that the withheld tests did not cover. [Iteration 4](benchmarks/iteration-4.md) fixed both defects and added an independent regeneration check to the harness. The skill-assisted runs then reached 6/7 functional, 11/11 conventions, and 3/3 mechanical passes, at about 2.2 times the baseline's solver time. In [iteration 5](benchmarks/iteration-5.md), real package-level API tests replaced the generator stubs. The independent check then caught a regeneration script that was not reproducible from a clean checkout. [Iteration 6](benchmarks/iteration-6.md) fixed that and reached 7/7 functional, but an unneeded serializer switch caused a Freezed miss and a non-interactive build failure. [Iteration 7](benchmarks/iteration-7.md) fixed those issues and returned conventions to 11/11. The one remaining miss was a generator warning left fatal in the API package's analysis. In [iteration 8](benchmarks/iteration-8.md), the skill-assisted runs passed every functional, convention, and mechanical check for the first time, at about 1.2 times the baseline's solver time. Two repeated runs of the same skill did not reproduce the full pass: across three runs the skill scored 20/21 functional, 31/33 conventions, and 9/9 mechanical, against 18/21, 3/33, and 4/9 without it. [Iteration 9](benchmarks/iteration-9.md) made the Freezed conversion a direct checklist trigger and required resubmitted queries to refresh. It passed every functional, convention, and mechanical check in all three runs (21/21, 33/33, 9/9), at about 1.5 times the baseline's solver time and 3.1 times its tokens.
