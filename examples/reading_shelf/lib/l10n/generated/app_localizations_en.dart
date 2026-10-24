// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Reading Shelf';

  @override
  String get search => 'Search';

  @override
  String get shelf => 'My shelf';

  @override
  String get settings => 'Settings';

  @override
  String get searchHint => 'Search by title or author';

  @override
  String booksFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count books found',
      one: '1 book found',
      zero: 'No books found',
    );
    return '$_temp0';
  }

  @override
  String pageLabel(int page, int pages) {
    return 'Page $page of $pages';
  }

  @override
  String get previousPage => 'Previous page';

  @override
  String get nextPage => 'Next page';

  @override
  String get noResults => 'No books match your search.';

  @override
  String get loadFailed => 'We couldn\'t load this information.';

  @override
  String get retry => 'Try again';

  @override
  String get networkError =>
      'Can\'t connect to the local API. Check that the server is running, then retry.';

  @override
  String get notFoundError => 'This book or reading entry could not be found.';

  @override
  String get unknownError => 'Something went wrong. Please try again.';

  @override
  String get invalidDataError =>
      'The server returned information we couldn\'t read.';

  @override
  String get bookNotFound => 'Book not found';

  @override
  String get bookDetail => 'Book details';

  @override
  String author(String name) {
    return 'by $name';
  }

  @override
  String publishedYear(int year) {
    return 'Published in $year';
  }

  @override
  String pageCount(int count) {
    return '$count pages';
  }

  @override
  String get addToShelf => 'Add to my shelf';

  @override
  String get editEntry => 'Edit reading record';

  @override
  String get createEntry => 'Start tracking this book';

  @override
  String get allBooks => 'All';

  @override
  String get wantToRead => 'Want to read';

  @override
  String get reading => 'Reading';

  @override
  String get finished => 'Finished';

  @override
  String readingProgress(int read, int total) {
    return '$read of $total pages';
  }

  @override
  String get noShelfEntries =>
      'Your shelf is empty. Search for a book to add it.';

  @override
  String get entryEditor => 'Reading record';

  @override
  String get back => 'Back';

  @override
  String get readingStatus => 'Reading status';

  @override
  String get pagesRead => 'Pages read';

  @override
  String get rating => 'Rating (optional)';

  @override
  String get noRating => 'No rating';

  @override
  String get note => 'Notes';

  @override
  String get noteHint => 'Write a note about this book';

  @override
  String get save => 'Save record';

  @override
  String get saving => 'Saving…';

  @override
  String get delete => 'Remove from shelf';

  @override
  String get cancel => 'Cancel';

  @override
  String get deleteConfirmTitle => 'Remove this book?';

  @override
  String get deleteConfirmMessage =>
      'This will delete your reading progress and note for this book.';

  @override
  String get unsavedTitle => 'Discard unsaved changes?';

  @override
  String get unsavedMessage => 'Your changes haven\'t been saved.';

  @override
  String get discardChanges => 'Discard changes';

  @override
  String get keepEditing => 'Keep editing';

  @override
  String validationPages(int total) {
    return 'Enter a page count from 0 to $total.';
  }

  @override
  String get validationNote => 'Notes can be up to 2000 characters.';

  @override
  String get saveFailed =>
      'Your changes are still here. Check the connection and try again.';

  @override
  String get entrySaved => 'Reading record saved.';

  @override
  String get entryDeleted => 'Book removed from your shelf.';

  @override
  String get language => 'Language';

  @override
  String get deviceLanguage => 'Use device language';

  @override
  String get english => 'English';

  @override
  String get japanese => '日本語';

  @override
  String get appearance => 'Appearance';

  @override
  String get deviceAppearance => 'Use device setting';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get settingsSaved => 'Preference saved.';

  @override
  String genre(String genre) {
    return '$genre';
  }

  @override
  String get openBook => 'Open book details';

  @override
  String get edit => 'Edit';

  @override
  String ratingStars(int rating) {
    return '$rating out of 5 stars';
  }

  @override
  String environmentBanner(String environment) {
    return '$environment environment';
  }

  @override
  String get environmentLocal => 'LOCAL';

  @override
  String get environmentStaging => 'STAGING';
}
