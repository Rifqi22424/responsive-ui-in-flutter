import 'package:flutter/foundation.dart';

import '../../domain/models/book.dart';

/// Sumber data buku. Disimpan di memori supaya fokus sesi ini tetap pada tampilan.
class BookRepository extends ChangeNotifier {
  final List<Book> _books = [
    const Book(id: 'b1', title: 'Dasar-Dasar Pemrograman Dart', author: 'Rina Kartika', category: 'Informatika', year: 2024, shelf: 'A1', synopsis: 'Pengantar bahasa Dart: variabel, fungsi, kelas, dan null safety, dengan latihan di setiap bab.'),
    const Book(id: 'b2', title: 'Flutter untuk Pemula', author: 'Dimas Prasetyo', category: 'Informatika', year: 2025, shelf: 'A1', synopsis: 'Membangun aplikasi mobile pertama dengan Flutter, dari widget dasar sampai navigasi.'),
    const Book(id: 'b3', title: 'Struktur Data dan Algoritma', author: 'Ahmad Fauzi', category: 'Informatika', year: 2023, shelf: 'A2', synopsis: 'Array, list, stack, queue, tree, dan graph, beserta analisis kompleksitas sederhana.'),
    const Book(id: 'b4', title: 'Kalkulus Jilid 1', author: 'Siti Nurhaliza', category: 'Matematika', year: 2022, shelf: 'B1', synopsis: 'Limit, turunan, dan integral untuk mahasiswa tahun pertama, dengan banyak contoh soal.'),
    const Book(id: 'b5', title: 'Statistika Terapan', author: 'Bayu Santoso', category: 'Matematika', year: 2024, shelf: 'B2', synopsis: 'Statistika deskriptif, peluang, dan uji hipotesis dengan contoh data kampus.'),
    const Book(id: 'b6', title: 'Pengantar Bisnis Digital', author: 'Maya Lestari', category: 'Bisnis', year: 2025, shelf: 'C1', synopsis: 'Model bisnis, pemasaran digital, dan studi kasus usaha rintisan di Indonesia.'),
    const Book(id: 'b7', title: 'Akuntansi Dasar', author: 'Hendra Wijaya', category: 'Bisnis', year: 2021, shelf: 'C2', synopsis: 'Persamaan akuntansi, jurnal, buku besar, dan laporan keuangan sederhana.'),
    const Book(id: 'b8', title: 'Laskar Kata', author: 'Nadia Putri', category: 'Sastra', year: 2020, shelf: 'D1', synopsis: 'Kumpulan cerpen tentang kehidupan mahasiswa di kota kecil.'),
  ];

  List<Book> get books => List.unmodifiable(_books);

  void toggleBorrow(String id) {
    final index = _books.indexWhere((book) => book.id == id);
    if (index == -1) return;
    _books[index] = _books[index].copyWith(borrowed: !_books[index].borrowed);
    notifyListeners();
  }
}
