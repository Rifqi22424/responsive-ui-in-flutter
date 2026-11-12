import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'catalog_screen.dart';
import 'catalog_view_model.dart';

/// Membuat CatalogViewModel dari repository di Provider, lalu menampilkan layar.
class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  late final CatalogViewModel _viewModel = CatalogViewModel(repository: context.read());

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CatalogScreen(viewModel: _viewModel);
}
