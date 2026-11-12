import 'package:flutter/material.dart';

import '../../../domain/models/book.dart';
import 'book_cover.dart';

/// Detail buku. Susunannya bergantung pada lebar ruang dari induknya.
class BookDetail extends StatelessWidget {
  const BookDetail({super.key, required this.book, required this.onToggleBorrow});

  final Book book;
  final VoidCallback onToggleBorrow;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // constraints = ruang dari induk (panel), bukan seluruh layar.
        final wide = constraints.maxWidth >= 600;
        final cover = SizedBox(width: 140, height: 200, child: BookCover(book: book, iconSize: 56));
        final info = _info(context);
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [cover, const SizedBox(width: 24), Expanded(child: info)],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Center(child: cover), const SizedBox(height: 24), info],
                ),
        );
      },
    );
  }

  Widget _info(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      key: const Key('detail-buku'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(book.title, style: text.headlineSmall),
        const SizedBox(height: 4),
        Text('${book.author} · ${book.year}', style: text.titleMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Chip(label: Text(book.category)),
            Chip(label: Text('Rak ${book.shelf}')),
          ],
        ),
        const SizedBox(height: 12),
        Text(book.synopsis, style: text.bodyLarge),
        const SizedBox(height: 20),
        FilledButton.icon(
          key: const Key('tombol-pinjam'),
          onPressed: onToggleBorrow,
          icon: Icon(book.borrowed ? Icons.bookmark_remove : Icons.bookmark_add),
          label: Text(book.borrowed ? 'Kembalikan' : 'Pinjam'),
        ),
      ],
    );
  }
}
