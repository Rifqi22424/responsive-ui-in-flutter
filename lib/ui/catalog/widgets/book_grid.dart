import 'package:flutter/material.dart';

import '../../../domain/models/book.dart';
import 'book_cover.dart';

/// Grid buku. Jumlah kolom dihitung sendiri dari lebar yang tersedia.
class BookGrid extends StatelessWidget {
  const BookGrid({super.key, required this.books, required this.onTap});

  final List<Book> books;
  final ValueChanged<Book> onTap;

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) return const Center(child: Text('Belum ada buku di sini.'));
    // Tinggi bagian teks ikut membesar jika pengguna memperbesar huruf.
    final textScaler = MediaQuery.textScalerOf(context);
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200, // kolom paling lebar 200 dp
        mainAxisExtent: 110 + textScaler.scale(76),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: books.length,
      itemBuilder: (context, i) {
        final book = books[i];
        final text = Theme.of(context).textTheme;
        return InkWell(
          key: ValueKey('buku-${book.id}'),
          borderRadius: BorderRadius.circular(8),
          onTap: () => onTap(book),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 100, width: double.infinity, child: BookCover(book: book)),
              const SizedBox(height: 8),
              Text(book.title, style: text.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
              Text(book.author, style: text.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        );
      },
    );
  }
}
