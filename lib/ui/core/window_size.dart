import 'dart:ui';

/// Kelas ukuran jendela menurut Material 3 (m3.material.io).
/// Compact < 600, medium 600–839, expanded >= 840 (lebar, dalam dp).
enum WindowSize {
  compact,
  medium,
  expanded;

  static const double mediumMin = 600;
  static const double expandedMin = 840;
  static const double compactHeightMax = 480;

  static WindowSize fromSize(Size size) {
    if (size.width < mediumMin) return compact;
    // HP landscape: lebar tetapi pendek, dua panel terlalu sempit.
    if (size.height < compactHeightMax) return medium;
    if (size.width < expandedMin) return medium;
    return expanded;
  }
}
