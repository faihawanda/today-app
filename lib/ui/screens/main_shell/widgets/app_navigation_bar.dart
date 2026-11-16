
import 'package:flutter/material.dart';

class AppNavigationBar extends StatelessWidget {
  const AppNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const Color activeColor = Color(0xFF0B0B0B);

  final List<IconData> icons = const [
    Icons.home_rounded,
    Icons.explore_rounded,
    Icons.bookmark_rounded,
    Icons.person_rounded,
  ];

  final List<String> labels = const [
    'Home',
    'Explore',
    'Bookmark',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(icons.length, (index) {
            final isSelected = currentIndex == index;

            return Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () => onTap(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  height: 48,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark
                            ? const Color(0xFFFA5536)
                            : activeColor)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      icons[index],
                      size: 23,
                      color: isSelected
                          ? Colors.white
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
