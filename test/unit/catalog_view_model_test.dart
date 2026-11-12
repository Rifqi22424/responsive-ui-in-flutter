import 'package:flutter_test/flutter_test.dart';
import 'package:sesi10_aplikasi_responsif/data/repositories/book_repository.dart';
import 'package:sesi10_aplikasi_responsif/ui/catalog/catalog_view_model.dart';

void main() {
  late CatalogViewModel viewModel;

  setUp(() => viewModel = CatalogViewModel(repository: BookRepository()));

  test('awalnya semua 8 buku tampil dan buku pertama terpilih', () {
    expect(viewModel.books, hasLength(8));
    expect(viewModel.selected?.id, 'b1');
  });

  test('memilih kategori Matematika menyaring daftar', () {
    viewModel.selectCategory('Matematika');
    expect(viewModel.books.map((b) => b.category), everyElement('Matematika'));
    expect(viewModel.books, hasLength(2));
  });

  test('buku yang dipinjam muncul di tab Pinjaman', () {
    viewModel.toggleBorrow(viewModel.books[2]);
    viewModel.selectTab(1);
    expect(viewModel.books.single.id, 'b3');
  });

  test('tab Pinjaman kosong tidak punya buku terpilih', () {
    viewModel.selectTab(1);
    expect(viewModel.selected, isNull);
  });
}
