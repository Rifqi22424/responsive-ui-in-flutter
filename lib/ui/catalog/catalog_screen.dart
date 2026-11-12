import 'package:flutter/material.dart';

import '../../domain/models/book.dart';
import '../core/window_size.dart';
import 'catalog_view_model.dart';
import 'widgets/book_detail.dart';
import 'widgets/book_grid.dart';
import 'widgets/book_list.dart';
import 'widgets/category_filter.dart';

/// Satu layar, tiga susunan. Resep 3 langkah: ukur, pilih, susun.
class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key, required this.viewModel});

  final CatalogViewModel viewModel;

  static const _destinations = [
    (icon: Icons.menu_book_outlined, label: 'Katalog'),
    (icon: Icons.bookmark_outline, label: 'Pinjaman'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        // Langkah 1 (ukur): ukuran jendela aplikasi, bukan ukuran perangkat.
        final size = MediaQuery.sizeOf(context);
        // Langkah 2 (pilih): ubah ukuran menjadi kelas ukuran Material 3.
        final windowSize = WindowSize.fromSize(size);
        // Langkah 3 (susun): widget yang sama, susunan berbeda.
        return switch (windowSize) {
          WindowSize.compact => _compact(context),
          WindowSize.medium => _medium(context),
          WindowSize.expanded => _expanded(context),
        };
      },
    );
  }

  // HP portrait: daftar + NavigationBar di bawah.
  Widget _compact(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NusaPerpus')),
      body: Column(
        children: [
          if (viewModel.tab == 0) _filter(),
          Expanded(child: BookList(books: viewModel.books, onTap: (b) => _openDetail(context, b))),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: viewModel.tab,
        onDestinationSelected: viewModel.selectTab,
        destinations: [
          for (final d in _destinations) NavigationDestination(icon: Icon(d.icon), label: d.label),
        ],
      ),
    );
  }

  // Tablet portrait dan HP landscape: NavigationRail + grid.
  Widget _medium(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NusaPerpus')),
      body: SafeArea(
        child: Row(
          children: [
            _rail(),
            const VerticalDivider(width: 1),
            Expanded(
              child: Column(
                children: [
                  if (viewModel.tab == 0) _filter(),
                  Expanded(child: BookGrid(books: viewModel.books, onTap: (b) => _openDetail(context, b))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tablet landscape dan desktop: daftar dan detail berdampingan.
  Widget _expanded(BuildContext context) {
    final selected = viewModel.selected;
    return Scaffold(
      appBar: AppBar(title: const Text('NusaPerpus')),
      body: SafeArea(
        child: Row(
          children: [
            _rail(),
            const VerticalDivider(width: 1),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  if (viewModel.tab == 0) _filter(),
                  Expanded(
                    child: BookList(
                      books: viewModel.books,
                      selectedId: selected?.id,
                      onTap: viewModel.select,
                    ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(
              flex: 3,
              child: selected == null
                  ? const Center(child: Text('Pilih buku untuk melihat detail.'))
                  : BookDetail(book: selected, onToggleBorrow: () => viewModel.toggleBorrow(selected)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rail() {
    return NavigationRail(
      selectedIndex: viewModel.tab,
      onDestinationSelected: viewModel.selectTab,
      labelType: NavigationRailLabelType.all,
      destinations: [
        for (final d in _destinations) NavigationRailDestination(icon: Icon(d.icon), label: Text(d.label)),
      ],
    );
  }

  Widget _filter() => CategoryFilter(
        categories: CatalogViewModel.categories,
        selected: viewModel.category,
        onSelected: viewModel.selectCategory,
      );

  // Di layar sempit, detail dibuka sebagai halaman baru.
  void _openDetail(BuildContext context, Book book) {
    viewModel.select(book);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            final current = viewModel.selected ?? book;
            return Scaffold(
              appBar: AppBar(title: Text(current.title)),
              body: SafeArea(
                child: BookDetail(book: current, onToggleBorrow: () => viewModel.toggleBorrow(current)),
              ),
            );
          },
        ),
      ),
    );
  }
}
