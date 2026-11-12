import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sesi10_aplikasi_responsif/app.dart';
import 'package:sesi10_aplikasi_responsif/config/dependencies.dart';
import 'package:sesi10_aplikasi_responsif/ui/catalog/widgets/book_detail.dart';
import 'package:sesi10_aplikasi_responsif/ui/catalog/widgets/book_grid.dart';
import 'package:sesi10_aplikasi_responsif/ui/catalog/widgets/book_list.dart';

/// Menjalankan aplikasi di layar tiruan dengan ukuran tertentu (piksel fisik).
Future<void> pumpApp(WidgetTester tester, Size physicalSize, double pixelRatio) async {
  tester.view.physicalSize = physicalSize;
  tester.view.devicePixelRatio = pixelRatio;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MultiProvider(providers: providers, child: const NusaPerpusApp()));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('HP portrait: daftar + NavigationBar', (tester) async {
    await pumpApp(tester, const Size(1170, 2532), 3); // 390 x 844 dp

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    expect(find.byType(BookList), findsOneWidget);
    expect(find.byType(BookDetail), findsNothing);
  });

  testWidgets('HP landscape: NavigationRail + grid', (tester) async {
    await pumpApp(tester, const Size(2532, 1170), 3); // 844 x 390 dp

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    expect(find.byType(BookGrid), findsOneWidget);
  });

  testWidgets('tablet landscape: daftar dan detail berdampingan', (tester) async {
    await pumpApp(tester, const Size(2048, 1536), 2); // 1024 x 768 dp

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(BookList), findsOneWidget);
    expect(find.byType(BookDetail), findsOneWidget);
  });

  testWidgets('tablet: mengetuk buku mengganti detail tanpa pindah halaman', (tester) async {
    await pumpApp(tester, const Size(2048, 1536), 2);

    await tester.tap(find.byKey(const ValueKey('buku-b4')));
    await tester.pumpAndSettle();

    expect(find.descendant(of: find.byType(BookDetail), matching: find.text('Kalkulus Jilid 1')),
        findsOneWidget);
    expect(find.byType(BookList), findsOneWidget); // daftar tetap terlihat
  });

  testWidgets('HP: mengetuk buku membuka halaman detail', (tester) async {
    await pumpApp(tester, const Size(1170, 2532), 3);

    await tester.tap(find.byKey(const ValueKey('buku-b4')));
    await tester.pumpAndSettle();

    expect(find.byType(BookDetail), findsOneWidget);
    expect(find.byType(BookList), findsNothing); // daftar tertutup halaman baru
  });

  testWidgets('memutar layar mengganti susunan tanpa kehilangan pilihan', (tester) async {
    await pumpApp(tester, const Size(2048, 1536), 2);
    await tester.tap(find.text('Bisnis'));
    await tester.pumpAndSettle();

    tester.view.physicalSize = const Size(1536, 2048); // tablet diputar: 768 x 1024 dp
    await tester.pumpAndSettle();

    expect(find.byType(BookGrid), findsOneWidget);
    expect(find.text('Pengantar Bisnis Digital'), findsOneWidget);
    expect(find.text('Kalkulus Jilid 1'), findsNothing); // filter Bisnis tetap aktif
  });

  testWidgets('huruf 200% di HP tidak menyebabkan overflow', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await pumpApp(tester, const Size(2532, 1170), 3); // grid di HP landscape

    expect(find.byType(BookGrid), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
