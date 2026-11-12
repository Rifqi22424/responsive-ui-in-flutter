import 'package:flutter/material.dart';

import '../../../domain/models/book.dart';

/// Sampul sederhana: warna menurut kategori + ikon.
class BookCover extends StatelessWidget {
  const BookCover({super.key, required this.book, this.iconSize = 32});

  final Book book;
  final double iconSize;

  static const _colors = {
    'Informatika': Color(0xFF2457C5),
    'Matematika': Color(0xFF6B4FBB),
    'Bisnis': Color(0xFFB7791F),
    'Sastra': Color(0xFFC2412D),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _colors[book.category] ?? Colors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Icon(Icons.auto_stories, color: Colors.white, size: iconSize),
    );
  }
}
