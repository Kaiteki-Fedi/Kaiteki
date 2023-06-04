import "package:flutter/material.dart";
import "package:kaiteki_core/social.dart";

class PostMetricBar extends StatelessWidget {
  final PostMetrics metrics;

  const PostMetricBar(this.metrics, {super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      (metrics.repeatCount, "repeats"),
      (metrics.favoriteCount, "favorites"),
    ];
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        for (final item in items)
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: item.$1.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: " ${item.$2}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
