# Flutter Riverpod Skill

Riverpod を使った Flutter アプリの設計・開発を支援する、Codex と Claude Code 向けの Agent Skill です。新規アプリの作成、機能追加、既存アプリの段階的なリファクタリングに利用できます。

[English](README.md) | 日本語

## 方針

- Flutter 公式の [Architecture Best Practices Skill](https://github.com/flutter/agent-plugins/blob/main/skills/flutter-apply-architecture-best-practices/SKILL.md) をアーキテクチャの基準とし、Riverpod 向けのガイダンスを加えます。
- 機能単位でコードを構成し、Riverpod の `Notifier` / `AsyncNotifier`、Freezed、`flutter_hooks` を使います。
- 新規 Flutter プロジェクトでは、検証済みの Flutter SDK を FVM と `.fvmrc` で固定します。
- 新規アプリと環境設定の作業ではlocal／staging／productionを分離し、Android・iOSは `flutter_flavorizr`、Webはビルド時設定を使います。VS Codeの起動構成も整備します。
- OpenAPI 仕様から OpenAPI Generator の `dart-dio` ジェネレーターで API クライアントを生成します。
- UI テーマを一元管理し、Flutter `gen_l10n` による多言語対応と型安全な `go_router` ルートを使います。
- 作業に合う場合は Flutter の追加 Agent Skill を参照します。その内容はこのリポジトリに複製しません。

## 利用方法

Skill の説明は [SKILL.md](SKILL.md)、目的別の詳しいガイドは [`references/`](references/) にあります。同じファイルを Codex と Claude Code の両方で利用できます。

### Codex

ディレクトリ名を `flutter-riverpod-skill` のまま、Codex の skills ディレクトリにクローンしてください。

```sh
# すべてのプロジェクトで利用する場合
git clone https://github.com/hiromoo/flutter-riverpod-skill.git ~/.agents/skills/flutter-riverpod-skill

# 特定のリポジトリだけで利用する場合（リポジトリのルートで実行）
git clone https://github.com/hiromoo/flutter-riverpod-skill.git .agents/skills/flutter-riverpod-skill
```

既存のクローンがある場合は、`ln -s "$PWD" ~/.agents/skills/flutter-riverpod-skill` のようにシンボリックリンクを作成しても構いません。Skill が表示されない場合は Codex を再起動してください。該当する Flutter タスクでは Codex が自動的に Skill を使用します。`$flutter-riverpod-skill` と記述するか、`/skills` から選択して明示的に呼び出すこともできます。

### Claude Code

ディレクトリ名を `flutter-riverpod-skill` のまま、Claude Code の skills ディレクトリにクローンしてください。

```sh
# すべてのプロジェクトで利用する場合
git clone https://github.com/hiromoo/flutter-riverpod-skill.git ~/.claude/skills/flutter-riverpod-skill

# 特定のプロジェクトだけで利用する場合（プロジェクトのルートで実行）
git clone https://github.com/hiromoo/flutter-riverpod-skill.git .claude/skills/flutter-riverpod-skill
```

既存のクローンがある場合は、`ln -s "$PWD" ~/.claude/skills/flutter-riverpod-skill` のようにシンボリックリンクを作成しても構いません。該当する Flutter タスクでは Claude Code が自動的に Skill を読み込みます。`/flutter-riverpod-skill` で明示的に呼び出すこともできます。

## サンプルアプリ

[Reading Shelf](examples/reading_shelf/README.md) は Shelf API を備えたAndroid・iOS・Web向けの読書記録アプリです。3環境の設定、Firebase CLI／FlutterFire CLIを使ったFirebase設定とSupabaseの初期化、左上の環境バナー、VS Codeからの起動を確認できます。localではSupabase CLIの公開キーとFirebase Emulator用の設定を使います。staging／productionでは各環境のクラウド設定と稼働中のShelf APIが必要です。

## 参考資料

- [Flutter agent-plugins の Skills](https://github.com/flutter/agent-plugins/tree/main/skills)
- [Flutter アーキテクチャ Skill](https://github.com/flutter/agent-plugins/blob/main/skills/flutter-apply-architecture-best-practices/SKILL.md)
- [Flutter の国際化ガイド](https://docs.flutter.dev/ui/internationalization)
- [OpenAPI Generator `dart-dio`](https://openapi-generator.tech/docs/generators/dart-dio/)

## リポジトリの構成

```text
SKILL.md
agents/openai.yaml   # Codex の UI 用メタデータ（Claude Code では使用しません）
references/
  architecture.md
  riverpod-and-models.md
  api-client.md
  ui-localization-and-navigation.md
  testing-and-generation.md
  environments-and-flavors.md
```

## ライセンス

このリポジトリは [MIT License](LICENSE) のもとで公開しています。

## スキルの評価

GPT-6 Lunaによるスキルあり／なしの実装を、GPT-6 Astraの採点と独立したFlutter/Dartの解析・テストで比較します。評価ケース、実行方法、結果の読み方は[評価ガイド](EVALUATION.md)を参照してください。

[初回の評価結果](benchmarks/iteration-1.md)では、スキルありで機能・規約の合格率が向上しました。一方で、実行時間とトークン使用量の増加や、Lunaが一貫して適用できなかった規約も確認されています。規約チェックリストを追加した[iteration 2](benchmarks/iteration-2.md)では、スキルありの規約合格率が27.3%から81.8%に上がり、機能の合格率は変わりませんでした。ただし、Refactorケースではdispose後の安全性チェックで後退がありました。[iteration 3](benchmarks/iteration-3.md)では、規約が11/11になり、機械チェックもすべて通過しました。一方で、独立テストが対象にしていない再試行と競合のバグが見つかり、機能の合格率は4/7に下がりました。[iteration 4](benchmarks/iteration-4.md)では両方のバグが直り、ハーネスには独立した再生成チェックを追加しました。その結果、スキルありは機能6/7、規約11/11、機械チェック3/3となりました。実行時間はスキルなしの約2.2倍です。[iteration 5](benchmarks/iteration-5.md)では、API パッケージのテストが生成器の雛形から手書きのテストに置き換わりました。その一方で、クリーンな環境では結果が変わる再生成スクリプトを、独立した再生成チェックが検出しました。[iteration 6](benchmarks/iteration-6.md)ではその問題が直り、機能は7/7になりました。一方で、必要のないシリアライザの切り替えから、Freezedの未適用と非対話ビルドの失敗が起きました。[iteration 7](benchmarks/iteration-7.md)ではそれらが直り、規約は11/11に戻りました。残った不合格は、API パッケージの静的解析で生成器由来の警告を抑制していなかった1件だけです。[iteration 8](benchmarks/iteration-8.md)では、スキルありが初めて機能・規約・機械チェックのすべてに合格しました。実行時間はスキルなしの約1.2倍です。ただし、同じスキルで2回繰り返したところ、全項目合格は再現しませんでした。3回合計では、スキルありが機能20/21、規約31/33、機械チェック9/9、スキルなしが18/21、3/33、4/9でした。[iteration 9](benchmarks/iteration-9.md)では、Freezed化をチェックリストの項目に直接入れ、同じ検索語を再送信したときに検索し直すことを必須にしました。その結果、3回すべてで機能・規約・機械チェックに全項目合格しました（21/21、33/33、9/9）。ただし、実行時間はスキルなしの約1.5倍、トークン数は約3.1倍です。
