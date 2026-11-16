import 'package:flutter/material.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../../data/models/article.dart';
import '../../../widgets/source_label.dart';

/// Article title + source, author, and publish time.
class DetailHeader extends StatelessWidget {
  const DetailHeader({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final author = article.author;
    final byline = author == null || author.isEmpty
        ? article.sourceName
        : author;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SourceLabel(name: article.sourceName),
        const SizedBox(height: 10),
        Text(
          article.title,
          style: theme.textTheme.headlineSmall?.copyWith(height: 1.25),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: scheme.primary.withValues(alpha: 0.12),
              child: Text(
                byline.characters.first.toUpperCase(),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: scheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    byline,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormatter.full(article.publishedAt),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}