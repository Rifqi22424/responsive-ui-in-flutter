import 'package:flutter/foundation.dart';

import '../../data/repositories/book_repository.dart';
import '../../domain/models/book.dart';

/// Logika layar katalog. Tidak tahu apa pun tentang ukuran layar.
class CatalogViewModel extends ChangeNotifier {
  CatalogViewModel({required BookRepository repository}) : _repository = repository {
    _repository.addListener(notifyListeners);
  }

  final BookRepository _repository;

  static const categories = ['Semua', 'Informatika', 'Matematika', 'Bisnis', 'Sastra'];

  int tab = 0; // 0 = Katalog, 1 = Pinjaman
  String category = 'Semua';
  String? _selectedId;

  List<Book> get books {
    final all = _repository.books;
    if (tab == 1) return all.where((b) => b.borrowed).toList();
    if (category == 'Semua') return all;
    return all.where((b) => b.category == category).toList();
  }

  /// Buku yang dibuka di panel detail (tablet). Default: buku pertama.
  Book? get selected {
    final list = books;
    if (list.isEmpty) return null;
    return list.firstWhere((b) => b.id == _selectedId, orElse: () => list.first);
  }

  void selectTab(int index) {
    tab = index;
    notifyListeners();
  }

  void selectCategory(String value) {
    category = value;
    notifyListeners();
  }

  void select(Book book) {
    _selectedId = book.id;
    notifyListeners();
  }

  void toggleBorrow(Book book) => _repository.toggleBorrow(book.id);

  @override
  void dispose() {
    _repository.removeListener(notifyListeners);
    super.dispose();
  }
}
