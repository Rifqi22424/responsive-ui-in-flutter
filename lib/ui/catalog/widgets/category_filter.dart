import 'package:flutter/material.dart';

/// Pilihan kategori. Wrap memindahkan chip ke baris baru jika tidak muat.
class CategoryFilter extends StatelessWidget {
  const CategoryFilter({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final c in categories)
              ChoiceChip(
                label: Text(c),
                selected: c == selected,
                onSelected: (_) => onSelected(c),
              ),
          ],
        ),
      ),
    );
  }
}
