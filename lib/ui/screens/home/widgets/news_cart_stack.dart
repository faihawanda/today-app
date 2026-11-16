
import 'package:flutter/material.dart';
import '../../../../data/models/article.dart';
import 'stacked_news_card.dart';

class NewsCardStack extends StatefulWidget {
  const NewsCardStack({
    super.key,
    required this.articles,
  });

  final List<Article> articles;

  @override
  State<NewsCardStack> createState() => _NewsCardStackState();
}

class _NewsCardStackState extends State<NewsCardStack> {
  int currentIndex = 0;
  double dragDistance = 0;

  void _nextArticle() {
    if (currentIndex < widget.articles.length - 1) {
      setState(() {
        currentIndex++;
      });
    }
  }

  void _previousArticle() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.articles.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,

          onHorizontalDragStart: (_) {
            dragDistance = 0;
          },

          onHorizontalDragUpdate: (details) {
            dragDistance += details.delta.dx;
          },

          onHorizontalDragEnd: (_) {
            if (dragDistance < -40) {
              _nextArticle();
            } else if (dragDistance > 40) {
              _previousArticle();
            }

            dragDistance = 0;
          },

          
child: SizedBox(
  height: 550,
  child: Stack(
    clipBehavior: Clip.none,
    children: [
      if (currentIndex < widget.articles.length - 2)
        Positioned(
          top: 5,
          left: 25,
          right: 12,
          child: Transform.rotate(
            angle: 0.035,
            child: _backCard(context, 0, 0.92),
          ),
        ),

      if (currentIndex < widget.articles.length - 1)
        Positioned(
          top: 17,
          left: 5,
          right: 22,
          child: Transform.rotate(
            angle: -0.025,
            child: _backCard(context, 1, 0.97),
          ),
        ),

      Positioned(
        top: 24,
        left: 0,
        right: 0,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.3, 0),
                end: Offset.zero,
              ).animate(animation),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: StackedNewsCard(
            key: ValueKey(currentIndex),
            article: widget.articles[currentIndex],
          ),
        ),
      ),
    ],
  ),
),

        ),

        const SizedBox(height: 5),

        Text(
          '${currentIndex + 1} / ${widget.articles.length}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  
Widget _backCard(
  BuildContext context,
  int colorIndex,
  double scale,
) {
  final theme = Theme.of(context);
  final scheme = theme.colorScheme;

  // colorIndex 0 = card paling belakang (paling menyatu dengan background),
  // colorIndex 1 = card tepat di belakang card depan.
  final blend = colorIndex == 0 ? 0.55 : 0.3;
  final color = Color.lerp(
    scheme.surface,
    theme.scaffoldBackgroundColor,
    blend,
  )!;

  return Transform.scale(
    scale: scale,
    alignment: Alignment.topCenter,
    child: Container(
      height: 510,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: scheme.outline.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    ),
  );
}

}
