
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/providers/headlines_provider.dart';

import '../../../../core/constants/news_category.dart';

class CategoryChips extends ConsumerWidget {
  const CategoryChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    const categories = NewsCategory.values;
    final selected = ref.watch(selectedCategoryProvider);

    return SizedBox(
      height: 54,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5,
        ),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 9),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selected;

          return ChoiceChip(
            label: Text(category.label),
            selected: isSelected,
            showCheckmark: false,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 7,
            ),
            labelStyle: TextStyle(
              fontSize: 13,
              fontWeight: isSelected
                  ? FontWeight.w600
                  : FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : theme.colorScheme.onSurface,
            ),
            backgroundColor: theme.colorScheme.surface,
            selectedColor: isDark
                ? const Color(0xFFFA5536)
                : const Color(0xFF0B0B0B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            onSelected: (_) {
              ref
                  .read(selectedCategoryProvider.notifier)
                  .select(category);
            },
          );
        },
      ),
    );
  }
}
