import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Reading Shelf'**
  String get appTitle;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @shelf.
  ///
  /// In en, this message translates to:
  /// **'My shelf'**
  String get shelf;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by title or author'**
  String get searchHint;

  /// Number of books in the search result.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No books found} =1{1 book found} other{{count} books found}}'**
  String booksFound(int count);

  /// Current result page.
  ///
  /// In en, this message translates to:
  /// **'Page {page} of {pages}'**
  String pageLabel(int page, int pages);

  /// No description provided for @previousPage.
  ///
  /// In en, this message translates to:
  /// **'Previous page'**
  String get previousPage;

  /// No description provided for @nextPage.
  ///
  /// In en, this message translates to:
  /// **'Next page'**
  String get nextPage;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No books match your search.'**
  String get noResults;

  /// No description provided for @loadFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load this information.'**
  String get loadFailed;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Can\'t connect to the local API. Check that the server is running, then retry.'**
  String get networkError;

  /// No description provided for @notFoundError.
  ///
  /// In en, this message translates to:
  /// **'This book or reading entry could not be found.'**
  String get notFoundError;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get unknownError;

  /// No description provided for @invalidDataError.
  ///
  /// In en, this message translates to:
  /// **'The server returned information we couldn\'t read.'**
  String get invalidDataError;

  /// No description provided for @bookNotFound.
  ///
  /// In en, this message translates to:
  /// **'Book not found'**
  String get bookNotFound;

  /// No description provided for @bookDetail.
  ///
  /// In en, this message translates to:
  /// **'Book details'**
  String get bookDetail;

  /// No description provided for @author.
  ///
  /// In en, this message translates to:
  /// **'by {name}'**
  String author(String name);

  /// No description provided for @publishedYear.
  ///
  /// In en, this message translates to:
  /// **'Published in {year}'**
  String publishedYear(int year);

  /// No description provided for @pageCount.
  ///
  /// In en, this message translates to:
  /// **'{count} pages'**
  String pageCount(int count);

  /// No description provided for @addToShelf.
  ///
  /// In en, this message translates to:
  /// **'Add to my shelf'**
  String get addToShelf;

  /// No description provided for @editEntry.
  ///
  /// In en, this message translates to:
  /// **'Edit reading record'**
  String get editEntry;

  /// No description provided for @createEntry.
  ///
  /// In en, this message translates to:
  /// **'Start tracking this book'**
  String get createEntry;

  /// No description provided for @allBooks.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allBooks;

  /// No description provided for @wantToRead.
  ///
  /// In en, this message translates to:
  /// **'Want to read'**
  String get wantToRead;

  /// No description provided for @reading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get reading;

  /// No description provided for @finished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get finished;

  /// No description provided for @readingProgress.
  ///
  /// In en, this message translates to:
  /// **'{read} of {total} pages'**
  String readingProgress(int read, int total);

  /// No description provided for @noShelfEntries.
  ///
  /// In en, this message translates to:
  /// **'Your shelf is empty. Search for a book to add it.'**
  String get noShelfEntries;

  /// No description provided for @entryEditor.
  ///
  /// In en, this message translates to:
  /// **'Reading record'**
  String get entryEditor;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @readingStatus.
  ///
  /// In en, this message translates to:
  /// **'Reading status'**
  String get readingStatus;

  /// No description provided for @pagesRead.
  ///
  /// In en, this message translates to:
  /// **'Pages read'**
  String get pagesRead;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating (optional)'**
  String get rating;

  /// No description provided for @noRating.
  ///
  /// In en, this message translates to:
  /// **'No rating'**
  String get noRating;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get note;

  /// No description provided for @noteHint.
  ///
  /// In en, this message translates to:
  /// **'Write a note about this book'**
  String get noteHint;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save record'**
  String get save;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get saving;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Remove from shelf'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove this book?'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will delete your reading progress and note for this book.'**
  String get deleteConfirmMessage;

  /// No description provided for @unsavedTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard unsaved changes?'**
  String get unsavedTitle;

  /// No description provided for @unsavedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your changes haven\'t been saved.'**
  String get unsavedMessage;

  /// No description provided for @discardChanges.
  ///
  /// In en, this message translates to:
  /// **'Discard changes'**
  String get discardChanges;

  /// No description provided for @keepEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get keepEditing;

  /// No description provided for @validationPages.
  ///
  /// In en, this message translates to:
  /// **'Enter a page count from 0 to {total}.'**
  String validationPages(int total);

  /// No description provided for @validationNote.
  ///
  /// In en, this message translates to:
  /// **'Notes can be up to 2000 characters.'**
  String get validationNote;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Your changes are still here. Check the connection and try again.'**
  String get saveFailed;

  /// No description provided for @entrySaved.
  ///
  /// In en, this message translates to:
  /// **'Reading record saved.'**
  String get entrySaved;

  /// No description provided for @entryDeleted.
  ///
  /// In en, this message translates to:
  /// **'Book removed from your shelf.'**
  String get entryDeleted;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @deviceLanguage.
  ///
  /// In en, this message translates to:
  /// **'Use device language'**
  String get deviceLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @japanese.
  ///
  /// In en, this message translates to:
  /// **'日本語'**
  String get japanese;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @deviceAppearance.
  ///
  /// In en, this message translates to:
  /// **'Use device setting'**
  String get deviceAppearance;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Preference saved.'**
  String get settingsSaved;

  /// No description provided for @genre.
  ///
  /// In en, this message translates to:
  /// **'{genre}'**
  String genre(String genre);

  /// No description provided for @openBook.
  ///
  /// In en, this message translates to:
  /// **'Open book details'**
  String get openBook;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @ratingStars.
  ///
  /// In en, this message translates to:
  /// **'{rating} out of 5 stars'**
  String ratingStars(int rating);

  /// Current non-production app environment.
  ///
  /// In en, this message translates to:
  /// **'{environment} environment'**
  String environmentBanner(String environment);

  /// No description provided for @environmentLocal.
  ///
  /// In en, this message translates to:
  /// **'LOCAL'**
  String get environmentLocal;

  /// No description provided for @environmentStaging.
  ///
  /// In en, this message translates to:
  /// **'STAGING'**
  String get environmentStaging;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
