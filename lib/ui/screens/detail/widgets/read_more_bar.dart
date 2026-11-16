import 'package:flutter/material.dart';

import '../../../../core/utils/url_helper.dart';

/// "Read full article" button pinned to the bottom of the screen.
class ReadMoreBar extends StatelessWidget {
  const ReadMoreBar({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(
          top: BorderSide(color: scheme.outline.withValues(alpha: 0.4)),
        ),
      ),
      child: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        child: FilledButton.icon(
          icon: const Icon(Icons.open_in_new_rounded),
          label: const Text('Read full article'),
          onPressed: () => UrlHelper.open(context, url),
        ),
      ),
    );
  }
}