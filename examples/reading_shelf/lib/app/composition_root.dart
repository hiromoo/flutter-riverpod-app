import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart' show Override;
import 'package:reading_shelf_api_client/reading_shelf_api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/catalog/application/catalog_providers.dart';
import '../features/catalog/data/api_books_repository.dart';
import '../features/reading/application/reading_providers.dart';
import '../features/reading/data/api_reading_repository.dart';
import '../features/settings/application/settings_providers.dart';
import '../features/settings/data/shared_preferences_settings_repository.dart';

List<Override> createAppOverrides(String apiBaseUrl) {
  final dio = Dio(BaseOptions(
    baseUrl: apiBaseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
    headers: const {'accept': 'application/json'},
  ));
  final client = ReadingShelfApiClient(dio: dio, basePathOverride: apiBaseUrl);
  final preferences = SharedPreferencesAsync();

  return [
    booksRepositoryProvider.overrideWith((ref) => ApiBooksRepository(client.getBooksApi())),
    readingRepositoryProvider.overrideWith((ref) => ApiReadingRepository(client.getReadingEntriesApi())),
    settingsRepositoryProvider.overrideWith(
      (ref) => SharedPreferencesSettingsRepository(preferences),
    ),
  ];
}
