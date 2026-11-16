import 'package:flutter/material.dart';

import 'package:news_app/core/constants/news_category.dart';
// TODO: sesuaikan path import ini dengan lokasi CategoryNewsScreen kamu
import 'package:news_app/ui/screens/search/category_news_screen.dart';

/// News category grid on the Explore page.
/// Tapping a category opens [CategoryNewsScreen].
class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  /// Categories that are not shown in the grid.
  static const _hidden = {'general'};

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final categories = NewsCategory.values
        .where((c) => !_hidden.contains(c.name.toLowerCase()))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Categories', style: textTheme.titleMedium),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 2.6,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            return _CategoryCard(
              category: category,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CategoryNewsScreen(category: category),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final NewsCategory category;
  final VoidCallback onTap;

  const _CategoryCard({required this.category, required this.onTap});

  IconData get _icon => switch (category.name.toLowerCase()) {
        'business' => Icons.business_center_rounded,
        'entertainment' => Icons.movie_rounded,
        'health' => Icons.favorite_rounded,
        'science' => Icons.science_rounded,
        'sports' => Icons.sports_soccer_rounded,
        'technology' => Icons.memory_rounded,
        _ => Icons.article_rounded,
      };

  Color get _iconColor => switch (category.name.toLowerCase()) {
        'business' => const Color(0xFFFF9800), // orange
        'entertainment' => const Color(0xFF9C27B0), // purple
        'health' => const Color(0xFFE53935), // red
        'science' => const Color(0xFF00ACC1), // teal
        'sports' => const Color(0xFF43A047), // green
        'technology' => const Color(0xFF3F51B5), // indigo
        _ => const Color(0xFF607D8B), // blue grey
      };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: scheme.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outline.withValues(alpha: 0.4)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              Icon(_icon, size: 24, color: _iconColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  category.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}