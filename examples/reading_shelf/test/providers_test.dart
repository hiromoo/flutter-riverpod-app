import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reading_shelf/app/composition_root.dart';
import 'package:reading_shelf/features/reading/application/reading_providers.dart';
import 'package:reading_shelf/features/reading/domain/reading_entry.dart';
import 'package:reading_shelf/features/reading/domain/reading_repository.dart';

void main() {
  test('reading entry action state is scoped to its book', () async {
    final repository = _ReadingRepository()..failSavingBookId = 'book-a';
    final container = ProviderContainer(
      retry: noAutomaticRetry,
      overrides: [readingRepositoryProvider.overrideWith((ref) => repository)],
    );
    addTearDown(container.dispose);

    final first = readingEntryActionsProvider('book-a');
    final second = readingEntryActionsProvider('book-b');
    await container.read(first.future);
    await container.read(second.future);

    final saved = await container.read(first.notifier).save(_entry('book-a'));
    expect(saved, isFalse);
    expect(container.read(first).hasError, isTrue);
    expect(container.read(second).hasError, isFalse);
  });
}

ReadingEntry _entry(String bookId) => ReadingEntry(
  bookId: bookId,
  status: ReadingStatus.reading,
  pagesRead: 1,
  rating: null,
  note: '',
  updatedAt: DateTime.utc(2026),
);

class _ReadingRepository implements ReadingRepository {
  String? failSavingBookId;

  @override
  Future<ReadingEntry?> getForBook(String bookId) async => null;

  @override
  Future<List<ReadingEntry>> list() async => const [];

  @override
  Future<ReadingEntry> save(ReadingEntry entry) async {
    if (entry.bookId == failSavingBookId) throw StateError('save failed');
    return entry;
  }

  @override
  Future<void> delete(String bookId) async {}
}
