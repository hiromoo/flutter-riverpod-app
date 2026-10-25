import 'package:flutter/material.dart';
import 'catalog_gateway.dart';

/// Existing catalog list. Unrelated to environment configuration.
class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key, required this.gateway});
  final CatalogGateway gateway;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: FutureBuilder(
      future: gateway.search(''),
      builder: (context, snapshot) => switch (snapshot.data) {
        null => const Center(child: CircularProgressIndicator()),
        final books => ListView(children: [
          for (final book in books)
            ListTile(key: Key('book-${book['id']}'), title: Text(book['title'] as String)),
        ]),
      },
    ),
  );
}
