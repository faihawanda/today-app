
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/providers/navigation_provider.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../../widgets/theme_toggle_button.dart';

class HomeAppBar extends ConsumerWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SliverAppBar(
      floating: false,
      snap: false,
      toolbarHeight: 88,
      titleSpacing: 20,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "What's happening Today?",
            style: theme.textTheme.headlineMedium?.copyWith(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.5,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            DateFormatter.today(),
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
      actions: [
        const ThemeToggleButton(),
        const SizedBox(width: 10),
      ],
    );
  }
}
