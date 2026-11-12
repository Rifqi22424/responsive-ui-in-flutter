import 'package:flutter/material.dart';

import '../../../domain/models/book.dart';
import 'book_cover.dart';

/// Daftar buku satu kolom. Dipakai di HP portrait dan di panel kiri tablet.
class BookList extends StatelessWidget {
  const BookList({super.key, required this.books, required this.onTap, this.selectedId});

  final List<Book> books;
  final ValueChanged<Book> onTap;
  final String? selectedId;

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) return const Center(child: Text('Belum ada buku di sini.'));
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, i) {
        final book = books[i];
        return ListTile(
          key: ValueKey('buku-${book.id}'),
          selected: book.id == selectedId,
          leading: SizedBox(width: 40, height: 56, child: BookCover(book: book, iconSize: 20)),
          title: Text(book.title, maxLines: 2, overflow: TextOverflow.ellipsis),
          subtitle: Text('${book.author} · ${book.year}', maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: book.borrowed ? const Icon(Icons.bookmark) : null,
          onTap: () => onTap(book),
        );
      },
    );
  }
}
