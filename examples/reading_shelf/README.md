# Reading Shelf

このサンプルは、このリポジトリの flutter-riverpod-app スキルを使ったAndroid・iOS・Web向けの読書記録アプリです。架空の書籍カタログを検索し、本棚への登録、読書記録の編集、言語・テーマ切替を試せます。local／staging／productionの接続設定を分離し、FirebaseとSupabaseの初期化例を含みます。

## 必要なもの

- FVM と Flutter 3.47.8（Dart 3.13.7 は同梱）
- Android SDK／Java（Android実行時）、Xcode（iOS実行時）、またはChrome（Web実行時）
- Docker、Supabase CLI、Firebase CLIとその対応Node.js／Java環境（localサービス実行時）
- Java 17 以降と Node.js/npm（OpenAPI クライアントを再生成する場合）

FVM が未導入の場合は、[公式手順](https://fvm.app/documentation/getting-started/installation)に従ってインストールします。SDK の固定値は `.fvmrc` にあります。初回はアプリのディレクトリで `fvm use 3.47.8` を実行すると、Flutter SDK と VS Code 用 SDK link を準備できます。

## 環境設定と起動

Android・iOSは `flavorizr.yaml` の設定を `flutter_flavorizr` 2.6.0で生成したlocal／staging／production flavorを使います。productionのapplication ID／bundle IDは `com.example.readingshelf`、localとstagingにはそれぞれ `.local`／`.staging` が付きます。WebではFlutter flavorを使わず、環境別のJSONを `--dart-define-from-file` で読み込みます。

JSONはOSの環境変数ではなく、ビルド時にDartへ渡す設定です。変更後はアプリを停止して再起動・再ビルドしてください。

localは青緑の `LOCAL`、stagingは濃いオレンジの `STAGING` をFlutter標準の `Banner` で左上に表示します。productionでは環境バナーを表示しません。右上のDEBUGバナーはdebugモードで引き続き表示されます。

`config/*.json.example` を同名の `.json` にコピーし、環境名、Shelf API、Supabase URL／公開キー、必要なローカル接続先を設定してください。FirebaseのAPI keyやapp IDはJSONへ転記せず、FlutterFire CLIの環境別生成ファイルを直接使います。設定JSONはGit管理外です。Firebase service accountやSupabase service-role keyをクライアント設定に入れないでください。

### localサービス

Docker、Supabase CLI、Firebase CLI（Node.js/npm）を用意して、Reading Shelfで一度だけ依存を解決します。

```sh
cd examples/reading_shelf
cp config/local.json.example config/local.json
fvm flutter pub get
fvm dart run build_runner build
fvm flutter gen-l10n
```

`config/local.json` の `SUPABASE_PUBLISHABLE_KEY` に `supabase status -o env` が表示するlocalのpublishable key（`sb_publishable_...`）を設定します。`PUBLISHABLE_KEY` の値を使い、旧 `ANON_KEY` のJWTは新規設定に使いません。FirebaseのAuth・Firestore EmulatorとSupabaseを別々のターミナルで起動してください。

```sh
cd examples/reading_shelf
firebase emulators:start --only auth,firestore --project demo-reading-shelf

cd examples/reading_shelf
supabase start
```

Supabase CLIが示すURLとpublishable key（`sb_publishable_...`）をlocal JSONへ反映します。local Firebase project IDは `demo-reading-shelf` です。Supabaseは他プロジェクトとの衝突を避け、API 56321・DB 56322・Studio 56323・メールUI 56324を使います。Firestore emulatorはShelf APIとのポート衝突を避けるため8081、Authは9099を使います。Firebase Emulatorはアプリ初期化時に自動接続します。Android EmulatorではAPI／Supabase／Firebaseに `10.0.2.2`、iOS Simulator／Webでは `localhost` を使います。実機では `LOCAL_HOST_OVERRIDE` に開発マシンのLAN IPを設定します。

VS CodeのRun and Debugから `Reading Shelf (Local Web)` または `Reading Shelf (Local Native)` を選ぶと、既存のShelf APIを起動して選択中のデバイス／Webでアプリを実行します。Native起動では必ず同じ環境名の `--flavor` と設定ファイルを使います。localのAndroidだけHTTP通信を許可しています。

### staging／productionの準備

Firebase CLIとFlutterFire CLIを用意します。生成スクリプトのオプションはFlutterFire CLI 1.4.0で確認しています。

```sh
npm install -g firebase-tools
fvm dart pub global activate flutterfire_cli 1.4.0
firebase login
```

localのEmulator実行には `firebase login` とFlutterFire CLIによる設定生成は不要です。

アプリのディレクトリで雛形をコピーし、それぞれの環境の値を入力します。

```sh
cp config/staging.json.example config/staging.json
cp config/production.json.example config/production.json
```

| 設定 | 入力する値 |
| --- | --- |
| `APP_ENV` | ファイル名に対応する `staging` または `production` |
| `API_BASE_URL` | `api/openapi.yaml` の仕様を実装した、稼働中のShelf APIのHTTPS URL |
| `SUPABASE_URL` / `SUPABASE_PUBLISHABLE_KEY` | 各環境のSupabase URLとpublishable key（`sb_publishable_...`） |
| `FIREBASE_EMULATOR_HOST` / `LOCAL_HOST_OVERRIDE` | staging／productionでは空文字のまま |

Firebaseではstaging／productionの別プロジェクトと、その中のWeb appを用意します。`firebase projects:list` と `firebase apps:list --project <project-id>` でIDを確認し、次のスクリプトで各環境の設定を生成します。最初は `--dry-run` でコマンドを確認できます。実行するとFlutterFire CLIが指定プロジェクトのAndroid／iOS appを識別子で照合し、未登録なら作成します。

```sh
python3 scripts/configure_firebase.py staging <staging-project-id> <staging-web-app-id> --dry-run
python3 scripts/configure_firebase.py staging <staging-project-id> <staging-web-app-id>
python3 scripts/configure_firebase.py production <production-project-id> <production-web-app-id>
```

`<...>` は実際のIDへ置き換えます。出力先は `lib/core/services/firebase/options/{staging,production}/firebase_options.dart` です。最初は起動時に生成手順を示すエラーになる雛形を置いています。スクリプトの成功時にだけ、対象環境の雛形をFlutterFire CLI出力へ置き換えます。生成された公開クライアント設定は差分を確認してコミットできます。手編集はせず、設定・プラットフォーム変更時に再生成してください。

実行時は選択した環境の `DefaultFirebaseOptions.currentPlatform` がプラットフォームに適した設定を返します。localだけは手管理の `demo-reading-shelf` 用設定を使い、クラウド用の生成ファイルが未設定でも起動できます。旧JSONにあった `FIREBASE_API_KEY`、`FIREBASE_*_APP_ID` などは不要になりました。

生成スクリプトは一時Flutterパッケージ内でFlutterFire CLIを動かし、Dart設定だけを取り込みます。現在のCore／Auth／Firestoreは明示的な `FirebaseOptions` で初期化するため、ネイティブ設定ファイルやGoogle-servicesプラグインを追加せず、既存flavorや `firebase.json` のEmulator設定を維持します。Crashlyticsなどネイティブ連携が必要な製品を追加する場合は、その時点でFlutterFireの環境別ネイティブ設定も導入してください。flavorizrの `google:firebase` processorは使用しません。

読書データは既存Shelf APIを使い、Firebase／Supabaseは初期化と接続設定までの導入です。

VS Codeで対象のWeb／Android／iOSデバイスを選び、`Reading Shelf (Staging Native)`／`Reading Shelf (Staging Web)` または対応するProduction構成を起動します。これらはローカルAPIを自動起動しません。Webのポートは3000です。ターミナルから実行する場合も環境名を揃えます。

```sh
fvm flutter run --flavor staging --dart-define-from-file=config/staging.json
fvm flutter run -d chrome --web-port 3000 --dart-define-from-file=config/staging.json
```

productionでは `staging` を `production` に置き換えます。Webには `--flavor` を渡しません。JSONを用意してもバックエンドの作成・起動・デプロイは行われません。

環境とプラットフォームごとのコマンドです。`<env>` は `local`、`staging`、`production` のいずれかで、`D` は `--dart-define-from-file=config/<env>.json` を表します。

| プラットフォーム | 実行 | ビルド |
|---|---|---|
| Web | `fvm flutter run -d chrome --web-port 3000 D` | `fvm flutter build web D` |
| Android | `fvm flutter run --flavor <env> D` | `fvm flutter build apk --flavor <env> D` |
| iOS | `fvm flutter run --flavor <env> D` | `fvm flutter build ios --flavor <env> D` |

`--dart-define-from-file` の値はコンパイル時に埋め込まれるため、変更後はホットリロードではなく完全な再起動または再ビルドが必要です。

flavor定義変更後にネイティブflavorを再生成する場合:

```sh
cd examples/reading_shelf
fvm dart run flutter_flavorizr -f
```

生成対象processorは `flavorizr.yaml` に限定しています。再生成後はDartの起動コード、VS Code設定、既存アイコンを差分確認してください。

## API クライアント生成

OpenAPI 仕様は `api/openapi.yaml`、generator CLI wrapper は `openapitools.json`、generator バージョンは同ファイル内で固定しています。Java と npm が利用可能な状態で:

```sh
./scripts/generate_api.sh
cd packages/api_client
fvm dart pub get
fvm dart run build_runner build
fvm dart test
```

OpenAPI Generator が出力したコードは手編集せず、生成 serializer もコミットします。`scripts/validate_generated.sh` は再生成差分と package の解析を検証します。

このサンプルでは generator の削除対象から手管理の `analysis_options.yaml` を `.openapi-generator-ignore` で除外しています。また `test/**` も除外し、generator が TODO だけのテスト雛形を出力しないようにしています。package の `test/` には手書きの serializer テストを置きます。再生成後も設定・テスト・README が残ることを確認してください。`built_value` の null 許容値は `Optional<T>.isPresent` を確認してから `.value` を読む必要があります。Riverpod runtime/generator の API は major version 間で異なるため、依存を選んだ直後に最小 provider の生成・解析を通してから feature 実装に進んでください。

## 検証

```sh
cd examples/reading_shelf/server
fvm dart test
fvm dart analyze
cd ..
fvm flutter gen-l10n
fvm dart run build_runner build
fvm flutter analyze lib test
fvm flutter test
python3 scripts/test_configure_firebase.py
fvm flutter build web --dart-define-from-file=config/local.json
fvm flutter build apk --flavor local --dart-define-from-file=config/local.json
fvm flutter build ios --simulator --no-codesign --flavor local --dart-define-from-file=config/local.json
```

環境設定テストは環境名、必須値、ネイティブflavorの不一致、localホスト選択とFirebase Emulator接続先を確認します。Widget testは英日環境バナーとproductionでの非表示も検証します。サーバーテストは検索・ページ送り、入力検証、保存後の再起動復元、削除、CORS preflight を確認します。API package test は null 許容記録の built_value serializer を、Widget test は repository override でローカライズされた検索結果を確認します。

### 確認済みの範囲

フレーバー導入時にlocal／staging／productionのWeb・Android APK・iOSシミュレーター向けビルドを確認しています。Firebase設定をFlutterFire CLI出力へ移す変更では、クラウドの実設定を生成・接続していません。staging／productionのFirebase生成ファイルは雛形のため、実行前に上記の生成スクリプトが必要です。localのSupabaseは公開キーを使ったAuth healthエンドポイントへの接続を確認しています。

実際の設定を入力した後は、アプリ起動、Shelf APIでの検索・保存、Firebase／Supabaseの必要な接続・権限を各環境で確認してください。現時点ではFirebase／Supabaseの業務機能がないため、SDKの初期化成功とサービスへの実リクエスト成功を分けて確認します。配布用の署名・ストア公開・Webホスティングも別途設定が必要です。

## CI／配信

リポジトリの [`.github/workflows/reading-shelf.yml`](../../.github/workflows/reading-shelf.yml) が、`.fvmrc` のFlutterで生成・解析・テストを実行し、生成物（`lib`、`pubspec.lock`、API client）の差分がないことを確認します。続けて、配信と同じ経路でstaging設定を注入し、WebとAndroid App Bundleをビルドします。upload鍵を登録していないため、App Bundleはdebug鍵で署名されます。

このサンプルにはストアやFirebase Hostingの配信先がないため、配信ワークフローは含めていません。実アプリでは [references/ci-and-delivery.md](../../references/ci-and-delivery.md) のテンプレートを使ってください。サンプルに含めている配信用の部品は次のとおりです。

- `scripts/ci/write_config.sh`: GitHub Environmentの変数から `config/ci.json` を生成します。必須値が空なら失敗します。`config/ci.json` はGit管理外です。
- `android/app/build.gradle.kts`: `ANDROID_KEYSTORE_PATH` などがあればupload鍵で署名し、なければdebug鍵で署名します。
- `ios/ExportOptions.plist`: App Store Connectへのアップロード設定です。`teamID` は空のままにします。アップロード用スクリプトが `APPLE_TEAM_ID` 変数から設定します。

```sh
cd examples/reading_shelf
APP_ENV=staging API_BASE_URL=https://api.staging.example.com SUPABASE_URL=https://staging.supabase.example.com \
  SUPABASE_PUBLISHABLE_KEY=sb_publishable_placeholder sh scripts/ci/write_config.sh
fvm flutter build web --release --dart-define-from-file=config/ci.json
fvm flutter build appbundle --release --flavor staging --dart-define-from-file=config/ci.json
```

上の値は仮の値なので、ビルドの確認にしか使えません。ストアへのアップロード、iOSのアーカイブと署名、Hostingへのデプロイは確認していません。

## Skill との対応

| Skill 方針 | サンプルでの例 |
| --- | --- |
| feature-first / Repository 境界 | `lib/features/{catalog,reading,settings}` |
| Riverpod provider / Notifier と composition root override | `application/` と `lib/app/composition_root.dart` |
| OpenAPI Generator dart-dio + built_value | `api/openapi.yaml`, `packages/api_client/` |
| Shelf API + JSON 永続化 | `server/lib/reading_shelf_server.dart` |
| `flutter_hooks` のローカル状態 | 検索・記録編集の `HookConsumerWidget` |
| Freezed domain model | feature の `domain/` |
| typed go_router routes | `lib/app/router.dart` |
| `gen_l10n`, `context.l.*`, Material 3 | `lib/l10n/`, `lib/core/l10n/`, `lib/app/` |
| CI検証と配信用の設定注入・署名 | `.github/workflows/reading-shelf.yml`, `scripts/ci/write_config.sh`, `android/app/build.gradle.kts` |

詳細な規約はリポジトリルートの [SKILL.md](../../SKILL.md) と `references/` を参照してください。

Supabaseのキー移行は[公式ガイド](https://supabase.com/docs/guides/getting-started/migrating-to-new-api-keys)を参照してください。このクライアントは `Supabase.initialize(publishableKey: ...)` を使います。`sb_secret_...`／旧service-roleキーはサーバー専用で、Flutter設定には含めません。publishable keyとユーザーのアクセストークンは別物です。
