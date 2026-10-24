# Existing Flutter application fixture

Flutter 3.47.8 / Dart 3.13.7, managed by the existing `.fvmrc`.
Use the provided pinned SDK; dependencies are prepared before the task starts.
The installed dependencies are available building blocks, not a required architecture.

## Stable host and test interfaces

UI tasks must expose `EvalApp({Key? key, required CatalogGateway gateway, Locale locale = const Locale('en')})`
from `lib/eval_app.dart`, and export `CatalogGateway` from that library.
The app includes its own MaterialApp (or MaterialApp.router).
The injected gateway is a transport seam returning JSON-like book objects
with string `id`, `title`, and `description` fields. Do not change its interface.

Search UI: a TextField with key `search-input`; submitting it starts a search.
An initial search uses the empty query. Results show book titles with tap targets
keyed `book-<id>`. Show a CircularProgressIndicator while loading,
`No books` / `本がありません` for empty results, and a button `Retry` / `再試行`
with key `retry` after an error. Retry repeats the failed query.
Locale comes from the host constructor. Feature-task book details must show
both title and description, including after opening the book from the list.

API tasks instead retain the public signatures documented in their task README.
