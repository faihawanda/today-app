
import 'package:flutter/material.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../data/models/article.dart';
import '../../../widgets/article_image.dart';
import '../../../widgets/bookmark_button.dart';

class StackedNewsCard extends StatelessWidget {
  const StackedNewsCard({
    super.key,
    required this.article,
  });

  final Article article;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => AppRouter.openArticle(context, article),
      child: Container(
        height: 510,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 18,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AUTHOR INFORMATION
            Row(
              children: [
                CircleAvatar(
                  radius: 17,
                  backgroundColor:
                      theme.colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.newspaper_rounded,
                    size: 19,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 9),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article.sourceName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        DateFormatter.relative(article.publishedAt),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),

                BookmarkButton(article: article),
              ],
            ),

            const SizedBox(height: 15),

            // HEADLINE
            Text(
              article.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 21,
                height: 1.2,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.7,
              ),
            ),

            const SizedBox(height: 13),

            // NEWS IMAGE
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ArticleImage(
                      url: article.imageUrl,
                      radius: 0,
                    ),

                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.75),
                          ],
                          stops: const [0.45, 1],
                        ),
                      ),
                    ),

                    Positioned(
                      left: 13,
                      right: 13,
                      bottom: 14,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.auto_awesome_rounded,
                                color: Colors.white70,
                                size: 13,
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                'QUICK RECAP',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 7),

                          Text(
                            article.description ??
                                'Discover the latest story and stay informed.',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              height: 1.3,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
