# NusaPerpus — Sesi 10: Membangun Aplikasi Responsif

Contoh aplikasi untuk mata kuliah **Pemrograman Perangkat Mobile (IF31033)**, Universitas Nusa Putra.

NusaPerpus adalah katalog perpustakaan kampus. Satu kode yang sama tampil berbeda sesuai ruang layar:

| Ukuran jendela | Kelas ukuran (Material 3) | Susunan NusaPerpus |
|---|---|---|
| HP portrait, 390 x 844 dp | **Compact** (lebar < 600) | Daftar buku + `NavigationBar` di bawah |
| HP landscape, 844 x 390 dp | Lebar, tetapi tinggi < 480 → **Medium** | `NavigationRail` + grid |
| Tablet portrait, 768 x 1024 dp | **Medium** (600–839) | `NavigationRail` + grid |
| Tablet landscape, 1024 x 768 dp | **Expanded** (≥ 840) | `NavigationRail` + daftar dan detail berdampingan |

Batas 600 dan 840 dp diambil dari Material 3 (m3.material.io, *window size classes*). Material 3 juga punya kelas **Large** (1200–1599) dan **Extra-large** (≥ 1600) untuk desktop; di aplikasi ini keduanya ikut susunan Expanded.

## Menjalankan

```bash
flutter pub get
flutter run -d chrome   # ubah lebar jendela browser untuk melihat susunan berganti
```

Di emulator atau HP, putar layar untuk berpindah antara portrait dan landscape.

Test (sekitar 2 detik, tanpa emulator):

```bash
flutter test
```

Ada 18 test: 9 unit test (`WindowSize`, `CatalogViewModel`) dan 9 widget test yang menjalankan aplikasi di ukuran HP, HP landscape, dan tablet.

## Struktur folder

```
lib/
├── main.dart
├── app.dart
├── config/dependencies.dart
├── domain/models/book.dart
├── data/repositories/book_repository.dart
└── ui/
    ├── core/window_size.dart          # compact / medium / expanded
    └── catalog/
        ├── catalog_view_model.dart    # tidak tahu apa pun soal ukuran layar
        ├── catalog_page.dart
        ├── catalog_screen.dart        # resep 3 langkah: ukur, pilih, susun
        └── widgets/
            ├── book_list.dart         # ListView
            ├── book_grid.dart         # GridView + textScaler
            ├── book_detail.dart       # LayoutBuilder
            ├── book_cover.dart
            └── category_filter.dart   # Wrap
test/
├── unit/
│   ├── window_size_test.dart
│   └── catalog_view_model_test.dart
└── widget/
    ├── responsive_layout_test.dart    # tester.view.physicalSize
    └── book_detail_test.dart
```

## Resep 3 langkah: ukur, pilih, susun

| Langkah | Pertanyaan | Alat di Flutter | Di NusaPerpus |
|---|---|---|---|
| 1. Ukur | Berapa ruang yang tersedia? | `MediaQuery.sizeOf(context)` untuk jendela, `LayoutBuilder` untuk ruang dari induk | `catalog_screen.dart`, `book_detail.dart` |
| 2. Pilih | Ruang ini termasuk kelas apa? | Batas 600 dan 840 dp | `WindowSize.fromSize()` |
| 3. Susun | Widget mana diletakkan di mana? | `NavigationBar`/`NavigationRail`, `Row`, `Expanded`, `Wrap`, `GridView` | `_compact()`, `_medium()`, `_expanded()` |

```dart
// Langkah 1 (ukur): ukuran jendela aplikasi, bukan ukuran perangkat.
final size = MediaQuery.sizeOf(context);
// Langkah 2 (pilih): ubah ukuran menjadi kelas ukuran Material 3.
final windowSize = WindowSize.fromSize(size);
// Langkah 3 (susun): widget yang sama, susunan berbeda.
return switch (windowSize) {
  WindowSize.compact => _compact(context),
  WindowSize.medium => _medium(context),
  WindowSize.expanded => _expanded(context),
};
```

`BookList`, `BookGrid`, dan `BookDetail` dipakai ulang di ketiga susunan. Yang berubah hanya letaknya.

## Langkah praktik

### Langkah 1 — Siapkan proyek

```bash
git clone https://github.com/Rifqi22424/responsive-ui-in-flutter.git
cd responsive-ui-in-flutter
flutter pub get
flutter run -d chrome
```

**Cek:** `flutter test` menampilkan `All tests passed!`, dan di Chrome terlihat daftar buku.

### Langkah 2 — Ukur ruang layar

Di `lib/ui/catalog/catalog_screen.dart`, tambahkan sementara di bawah baris `final windowSize = ...`:

```dart
debugPrint('ukuran: $size, kelas: $windowSize');
```

Simpan (hot reload), lalu perkecil dan perlebar jendela Chrome.

**Cek:** konsol menampilkan ukuran baru setiap kali jendela berubah, dan kelas berganti dari `compact` ke `medium` saat lebar melewati 600.

### Langkah 3 — Pilih kelas ukuran

Buka `lib/ui/core/window_size.dart` dan `test/unit/window_size_test.dart`. Ubah sementara `mediumMin = 600` menjadi `700`, lalu jalankan:

```bash
flutter test test/unit/window_size_test.dart
```

**Cek:** test "599 dp masih compact, 600 dp sudah medium" gagal. Kembalikan ke `600`, test hijau lagi.

### Langkah 4 — Susun ulang: daftar dan detail berdampingan

Perlebar jendela Chrome sampai lebih dari 840 dp, lalu ketuk beberapa buku. Kemudian perkecil lagi di bawah 600 dan ketuk buku.

**Cek:** di jendela lebar, detail berganti di panel kanan tanpa pindah halaman. Di jendela sempit, detail dibuka sebagai halaman baru dengan tombol kembali.

### Langkah 5 — LayoutBuilder: ruang dari induk

Di `lib/ui/catalog/widgets/book_detail.dart`, ubah sementara `constraints.maxWidth >= 600` menjadi `>= 500`.

**Cek:** di tablet landscape (jendela 1024 dp), sampul pindah ke samping teks, karena panel detail lebarnya sekitar 565 dp. Kembalikan ke `600`.

### Langkah 6 — Huruf besar dan widget test

Di `lib/ui/catalog/widgets/book_grid.dart`, ganti sementara `mainAxisExtent: 110 + textScaler.scale(76)` menjadi `mainAxisExtent: 186`, lalu jalankan:

```bash
flutter test test/widget/responsive_layout_test.dart
```

**Cek:** test "huruf 200% di HP tidak menyebabkan overflow" gagal dengan `A RenderFlex overflowed by 34 pixels on the bottom.` Kembalikan barisnya, semua test hijau.

## Troubleshooting

| Masalah | Penyebab | Solusi |
|---|---|---|
| Garis kuning-hitam, `A RenderFlex overflowed by 110 pixels on the right` | Lebar ditulis tetap (`SizedBox(width: 300)`) dan tidak muat di HP | Pakai `Expanded`/`Flexible` atau `Wrap` |
| `Vertical viewport was given unbounded width` | `ListView` di dalam `Row` tanpa batas lebar | Bungkus `ListView` dengan `Expanded` |
| Teks terpotong saat ukuran huruf HP diperbesar | Tinggi kotak ditulis tetap | Hitung tinggi bagian teks dengan `MediaQuery.textScalerOf(context).scale(...)` |
| Susunan tidak berubah saat HP diputar atau di split screen | Memeriksa jenis perangkat ("apakah ini tablet"), atau ukuran disimpan sekali di `initState` | Baca `MediaQuery.sizeOf(context)` di dalam `build` dan putuskan dari lebar jendela |
| Konten tertutup notch atau sudut layar di landscape | Tidak memakai `SafeArea` | Bungkus `body` dengan `SafeArea` |
