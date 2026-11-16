
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/providers/headlines_provider.dart';
import 'package:news_app/providers/navigation_provider.dart';

import 'package:news_app/ui/screens/home/widgets/news_cart_stack.dart';
import 'package:news_app/ui/widgets/empty_state.dart';
import 'package:news_app/ui/widgets/error_state.dart';
import 'package:news_app/ui/widgets/loading_skeleton.dart';

class HeadlinesSection extends ConsumerWidget {
  const HeadlinesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(selectedCategoryProvider);
    final headlines = ref.watch(headlinesProvider(category));

    return headlines.when(
      // LOADING
      loading: () => const SliverToBoxAdapter(
        child: LoadingSkeleton(),
      ),

      // ERROR
      error: (error, _) => SliverFillRemaining(
        hasScrollBody: false,
        child: ErrorState(
          error: error,
          onRetry: () => ref.invalidate(
            headlinesProvider(category),
          ),
        ),
      ),

      data: (articles) {
        if (articles.isEmpty) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyState(
              icon: Icons.newspaper_rounded,
              title: 'No news available',
              message: 'Try selecting another category or pull down to refresh.',
            ),
          );
        }

        return SliverToBoxAdapter(
          child: Column(
            children: [
              NewsCardStack(
                articles: articles,
              ),

              const SizedBox(height: 15),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      ref.read(navigationProvider.notifier).select(1);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 119, 119, 119),
                      side: const BorderSide(
                        color: Color.fromARGB(255, 142, 142, 142),
                        width: 1,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),

                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Explore More',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
