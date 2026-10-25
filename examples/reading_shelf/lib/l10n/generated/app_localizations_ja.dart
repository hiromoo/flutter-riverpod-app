// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '読書本棚';

  @override
  String get search => '本を探す';

  @override
  String get shelf => 'マイ本棚';

  @override
  String get settings => '設定';

  @override
  String get searchHint => 'タイトルまたは著者で検索';

  @override
  String booksFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 冊の本が見つかりました',
      zero: '本が見つかりません',
    );
    return '$_temp0';
  }

  @override
  String pageLabel(int page, int pages) {
    return '$pages ページ中 $page ページ';
  }

  @override
  String get previousPage => '前のページ';

  @override
  String get nextPage => '次のページ';

  @override
  String get noResults => '検索に一致する本がありません。';

  @override
  String get loadFailed => '情報を読み込めませんでした。';

  @override
  String get retry => '再試行';

  @override
  String get networkError => 'ローカル API に接続できません。サーバーの起動を確認して再試行してください。';

  @override
  String get notFoundError => '本または読書記録が見つかりません。';

  @override
  String get unknownError => '問題が発生しました。もう一度お試しください。';

  @override
  String get invalidDataError => 'サーバーから読み取れない情報が返されました。';

  @override
  String get bookNotFound => '本が見つかりません';

  @override
  String get bookDetail => '本の詳細';

  @override
  String author(String name) {
    return '著者：$name';
  }

  @override
  String publishedYear(int year) {
    return '$year 年刊';
  }

  @override
  String pageCount(int count) {
    return '$count ページ';
  }

  @override
  String get addToShelf => '本棚に追加';

  @override
  String get editEntry => '読書記録を編集';

  @override
  String get createEntry => '読書記録をつける';

  @override
  String get allBooks => 'すべて';

  @override
  String get wantToRead => '読みたい';

  @override
  String get reading => '読書中';

  @override
  String get finished => '読了';

  @override
  String readingProgress(int read, int total) {
    return '$total ページ中 $read ページ';
  }

  @override
  String get noShelfEntries => '本棚は空です。検索して本を追加しましょう。';

  @override
  String get entryEditor => '読書記録';

  @override
  String get back => '戻る';

  @override
  String get readingStatus => '読書状況';

  @override
  String get pagesRead => '読んだページ数';

  @override
  String get rating => '評価（任意）';

  @override
  String get noRating => '評価なし';

  @override
  String get note => 'メモ';

  @override
  String get noteHint => '本についてメモを書く';

  @override
  String get save => '記録を保存';

  @override
  String get saving => '保存中…';

  @override
  String get delete => '本棚から削除';

  @override
  String get cancel => 'キャンセル';

  @override
  String get deleteConfirmTitle => 'この本を削除しますか？';

  @override
  String get deleteConfirmMessage => '読書の進捗とメモも削除されます。';

  @override
  String get unsavedTitle => '変更を破棄しますか？';

  @override
  String get unsavedMessage => 'まだ保存されていない変更があります。';

  @override
  String get discardChanges => '変更を破棄';

  @override
  String get keepEditing => '編集を続ける';

  @override
  String validationPages(int total) {
    return '0 から $total までのページ数を入力してください。';
  }

  @override
  String get validationNote => 'メモは 2000 文字以内で入力してください。';

  @override
  String get saveFailed => '入力内容は保持されています。接続を確認して再試行してください。';

  @override
  String get entrySaved => '読書記録を保存しました。';

  @override
  String get entryDeleted => '本棚から削除しました。';

  @override
  String get language => '言語';

  @override
  String get deviceLanguage => '端末の言語を使用';

  @override
  String get english => 'English';

  @override
  String get japanese => '日本語';

  @override
  String get appearance => '外観';

  @override
  String get deviceAppearance => '端末の設定を使用';

  @override
  String get lightTheme => 'ライト';

  @override
  String get darkTheme => 'ダーク';

  @override
  String get settingsSaved => '設定を保存しました。';

  @override
  String genre(String genre) {
    return '$genre';
  }

  @override
  String get openBook => '本の詳細を開く';

  @override
  String get edit => '編集';

  @override
  String ratingStars(int rating) {
    return '5 つ星中 $rating つ星';
  }

  @override
  String environmentBanner(String environment) {
    return '$environment 環境';
  }

  @override
  String get environmentLocal => 'LOCAL';

  @override
  String get environmentStaging => 'STAGING';
}
