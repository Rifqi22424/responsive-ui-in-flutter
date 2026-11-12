import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sesi10_aplikasi_responsif/data/repositories/book_repository.dart';
import 'package:sesi10_aplikasi_responsif/ui/catalog/widgets/book_detail.dart';

void main() {
  final book = BookRepository().books.first;

  Widget detailIn(double width) => MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(width: width, child: BookDetail(book: book, onToggleBorrow: () {})),
          ),
        ),
      );

  testWidgets('ruang induk sempit: sampul di atas teks', (tester) async {
    await tester.pumpWidget(detailIn(400));
    final cover = tester.getTopLeft(find.byIcon(Icons.auto_stories));
    final title = tester.getTopLeft(find.text(book.title));
    expect(title.dy, greaterThan(cover.dy + 50)); // judul di bawah sampul
  });

  testWidgets('ruang induk lebar: sampul di samping teks', (tester) async {
    await tester.pumpWidget(detailIn(700));
    final cover = tester.getTopRight(find.byIcon(Icons.auto_stories));
    final title = tester.getTopLeft(find.text(book.title));
    expect(title.dx, greaterThan(cover.dx)); // judul di kanan sampul
  });
}
