
import 'package:flutter/material.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../data/models/article.dart';
import '../../../widgets/article_image.dart';
import '../../../widgets/bookmark_button.dart';

class FeaturedArticleCard extends StatelessWidget {
  const FeaturedArticleCard({
    super.key,
    required this.article,
  });

  final Article article;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final description = article.description;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => AppRouter.openArticle(context, article),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: ArticleImage(
                      url: article.imageUrl,
                      radius: 0,
                    ),
                  ),

                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.75),
                          ],
                          stops: const [0.35, 1],
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 14,
                    left: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFA5536),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'TOP STORY',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 7,
                    right: 7,
                    child: BookmarkButton(article: article),
                  ),

                  Positioned(
                    left: 18,
                    right: 18,
                    bottom: 18,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.sourceName.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 9),
                        Text(
                          article.title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            height: 1.2,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (description != null && description.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium,
              ),
            ],

            const SizedBox(height: 9),

            Row(
              children: [
                Icon(
                  Icons.schedule_rounded,
                  size: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 5),
                Text(
                  DateFormatter.relative(article.publishedAt),
                  style: theme.textTheme.bodySmall,
                ),
                const Spacer(),
                Text(
                  'READ STORY',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: const Color(0xFFFA5536),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 14,
                  color: Color(0xFFFA5536),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
