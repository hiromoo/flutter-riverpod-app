import 'package:flutter/material.dart';
import 'catalog_gateway.dart';
import 'catalog_screen.dart';
export 'catalog_gateway.dart';

class EvalApp extends StatelessWidget {
  const EvalApp({super.key, required this.gateway, this.locale = const Locale('en')});
  final CatalogGateway gateway;
  final Locale locale;
  @override
  Widget build(BuildContext context) => MaterialApp(
    locale: locale,
    home: CatalogScreen(gateway: gateway),
  );
}
