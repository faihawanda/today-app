import 'package:flutter/material.dart';

import 'widgets/search_input.dart';
import 'widgets/search_results.dart';

/// Explore page: search bar + results / category grid and topic suggestions.
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Text("Explore Today's news", style: textTheme.headlineMedium?.copyWith(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.5,
            )),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SearchInput(),
          ),
          const SizedBox(height: 8),
          const Expanded(child: SearchResults()),
        ],
      ),
    );
  }
}