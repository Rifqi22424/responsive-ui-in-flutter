/// Satu buku di katalog perpustakaan kampus.
class Book {
  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.year,
    required this.shelf,
    required this.synopsis,
    this.borrowed = false,
  });

  final String id;
  final String title;
  final String author;
  final String category;
  final int year;
  final String shelf; // lokasi rak, misalnya "A2"
  final String synopsis;
  final bool borrowed; // sedang dipinjam oleh pengguna ini

  Book copyWith({bool? borrowed}) => Book(
        id: id,
        title: title,
        author: author,
        category: category,
        year: year,
        shelf: shelf,
        synopsis: synopsis,
        borrowed: borrowed ?? this.borrowed,
      );
}
