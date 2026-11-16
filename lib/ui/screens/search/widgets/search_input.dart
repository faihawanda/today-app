import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/providers/search_provider.dart';

class SearchInput extends ConsumerStatefulWidget {
  const SearchInput({super.key});

  @override
  ConsumerState<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends ConsumerState<SearchInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    ref.read(searchQueryProvider.notifier).clear();
  }

  @override
  Widget build(BuildContext context) {
    // Sync the text field when the query changes from outside
    // (e.g. tapping a popular topic).
    ref.listen(searchQueryProvider, (_, next) {
      if (_controller.text != next) _controller.text = next;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    });
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SearchBar(
      controller: _controller,
      hintText: 'Search news, topics, or people',
      elevation: const WidgetStatePropertyAll(0),
      backgroundColor: WidgetStatePropertyAll(scheme.surface),
      surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
      side: WidgetStatePropertyAll(
        BorderSide(color: scheme.outline.withValues(alpha: 0.4)),
      ),
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 16),
      ),
      textStyle: WidgetStatePropertyAll(
        textTheme.bodyLarge?.copyWith(height: 1.2),
      ),
      hintStyle: WidgetStatePropertyAll(
        textTheme.bodyLarge?.copyWith(
          height: 1.2,
          color: textTheme.bodyMedium?.color,
        ),
      ),
      leading: const Icon(Icons.search_rounded),
      textInputAction: TextInputAction.search,
      onSubmitted: (value) {
        ref.read(searchQueryProvider.notifier).submit(value);
      },
      trailing: [
        ListenableBuilder(
          listenable: _controller,
          builder: (_, _) => _controller.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  tooltip: 'Clear',
                  icon: const Icon(Icons.close_rounded),
                  onPressed: _clear,
                ),
        ),
      ],
    );
  }
}