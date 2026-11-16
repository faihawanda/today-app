import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/bookmark_provider.dart';
import '../../widgets/error_state.dart';
import '../../widgets/theme_toggle_button.dart';
import 'widgets/bookmark_item.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final bookmarksAsync = ref.watch(bookmarksProvider);

    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 8, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "Reading list",
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          bookmarksAsync.when(
            // While data is loading
            loading: () => const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            ),

            // When an error occurs
            error: (error, stackTrace) => SliverFillRemaining(
              hasScrollBody: false,
              child: ErrorState(
                error: error,
                onRetry: () => ref.invalidate(bookmarksProvider),
              ),
            ),

            // When data is loaded
            data: (bookmarks) {
              if (bookmarks.isEmpty) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyBookmarks(),
                );
              }

              final scheme = theme.colorScheme;

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                sliver: SliverList.separated(
                  itemCount: bookmarks.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (_, index) {
                    return Material(
                      color: scheme.surface, // white in light mode
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: scheme.outline.withValues(alpha: 0.4)),
                      ),
                      child: BookmarkItem(article: bookmarks[index]),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Empty state with a white circle behind the icon.
class _EmptyBookmarks extends StatelessWidget {
  const _EmptyBookmarks();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 0, 32, 80),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: scheme.surface, // white in light mode
                shape: BoxShape.circle,
                border: Border.all(
                  color: scheme.outline.withValues(alpha: 0.4),
                ),
              ),
              child: Icon(
                Icons.bookmark_rounded,
                size: 30,
                color: scheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No saved articles yet',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the bookmark icon on an article\nto read it later.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}