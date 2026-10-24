import 'catalog_gateway.dart';

/// In-memory gateway used by the runnable app until a real backend is connected.
class DemoGateway implements CatalogGateway {
  const DemoGateway();
  static const _books = [
    {'id': 'dune', 'title': 'Dune', 'description': 'Desert planet.'},
    {'id': 'emma', 'title': 'Emma', 'description': 'Village matchmaking.'},
  ];
  @override
  Future<List<Map<String, dynamic>>> search(String query) async =>
      [for (final book in _books) if (book['title']!.toLowerCase().contains(query.toLowerCase())) book];
  @override
  Future<Map<String, dynamic>> get(String id) async => _books.firstWhere((book) => book['id'] == id);
}
