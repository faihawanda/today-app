import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:news_app/core/constants/news_category.dart';
import 'package:news_app/providers/headlines_provider.dart';
import 'package:news_app/ui/widgets/article_tile.dart';
import 'package:news_app/ui/widgets/empty_state.dart';
import 'package:news_app/ui/widgets/error_state.dart';
import 'package:news_app/ui/widgets/loading_skeleton.dart';

class CategoryNewsScreen extends ConsumerWidget {
  final NewsCategory category;

  const CategoryNewsScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final headlines = ref.watch(headlinesProvider(category));

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: scheme.surface,
        title: Text(
          category.label,
          style: theme.textTheme.headlineSmall,
        ),
      ),
      body: headlines.when(
        loading: () => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: LoadingSkeleton(),
        ),
        error: (error, stackTrace) => ErrorState(
          error: error,
          onRetry: () {
            ref.invalidate(headlinesProvider(category));
          },
        ),
        data: (articles) {
          if (articles.isEmpty) {
            return EmptyState(
              icon: Icons.article_outlined,
              title: 'No news yet',
              message: 'There is no news available for this category yet.',
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.only(top: 8, bottom: 24),
            itemCount: articles.length,
            separatorBuilder: (_, _) => const Divider(
              indent: 16,
              endIndent: 16,
            ),
            itemBuilder: (context, index) {
              return ArticleTile(
                article: articles[index],
              );
            },
          );
        },
      ),
    );
  }
}