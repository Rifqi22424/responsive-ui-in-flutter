import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:sesi10_aplikasi_responsif/ui/core/window_size.dart';

void main() {
  group('WindowSize.fromSize (nilai batas Material 3)', () {
    test('599 dp masih compact, 600 dp sudah medium', () {
      expect(WindowSize.fromSize(const Size(599, 900)), WindowSize.compact);
      expect(WindowSize.fromSize(const Size(600, 900)), WindowSize.medium);
    });

    test('839 dp masih medium, 840 dp sudah expanded', () {
      expect(WindowSize.fromSize(const Size(839, 900)), WindowSize.medium);
      expect(WindowSize.fromSize(const Size(840, 900)), WindowSize.expanded);
    });
  });

  test('HP portrait 390 x 844 adalah compact', () {
    expect(WindowSize.fromSize(const Size(390, 844)), WindowSize.compact);
  });

  test('HP landscape 844 x 390 lebar tetapi pendek, jadi medium', () {
    expect(WindowSize.fromSize(const Size(844, 390)), WindowSize.medium);
  });

  test('tablet landscape 1024 x 768 adalah expanded', () {
    expect(WindowSize.fromSize(const Size(1024, 768)), WindowSize.expanded);
  });
}
