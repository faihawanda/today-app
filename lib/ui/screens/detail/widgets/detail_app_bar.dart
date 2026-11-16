import 'package:flutter/material.dart';

import '../../../../data/models/article.dart';
import '../../../widgets/article_image.dart';
import '../../../widgets/bookmark_button.dart';

/// App bar with a large image that shrinks on scroll.
/// The image fades into a rounded white sheet that holds the article content.
class DetailAppBar extends StatelessWidget {
  const DetailAppBar({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SliverAppBar(
      pinned: true,
      stretch: true,
      expandedHeight: 300,
      backgroundColor: scheme.surface,
      leading: Padding(
        padding: const EdgeInsets.all(6),
        child: IconButton.filledTonal(
          tooltip: 'Back',
          style: IconButton.styleFrom(
            backgroundColor: scheme.surface.withValues(alpha: 0.9),
            foregroundColor: scheme.onSurface,
          ),
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      actions: [
        BookmarkButton(article: article, tonal: true),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: ArticleImage(url: article.imageUrl, radius: 0),
      ),
      // Rounded top edge of the content sheet, overlapping the image.
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(24),
        child: Container(
          height: 24,
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
        ),
      ),
    );
  }
}