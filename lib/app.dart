import 'package:flutter/material.dart';

import 'ui/catalog/catalog_page.dart';

class NusaPerpusApp extends StatelessWidget {
  const NusaPerpusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NusaPerpus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: const Color(0xFF0E7C66)),
      home: const CatalogPage(),
    );
  }
}
