import 'package:flutter/material.dart';

import '../../../../data/models/article.dart';

/// Summary + snippet of the article content.
///
/// NewsAPI only returns ~200 characters of content, so we show a note
/// asking the user to read the full version on the source site.
class DetailContent extends StatelessWidget {
  const DetailContent({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final description = article.description ?? '';
    final content = article.cleanContent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (description.isNotEmpty)
          Text(
            description,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              height: 1.5,
            ),
          ),
        if (content.isNotEmpty && content != description) ...[
          const SizedBox(height: 16),
          Text(
            content,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ],
        const SizedBox(height: 28),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: scheme.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: scheme.outline.withValues(alpha: 0.4)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded, color: scheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'This is a preview. Read the full article on '
                  '${article.sourceName}.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}