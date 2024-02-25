import "dart:math";

import "package:flutter/material.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";
import "package:kaiteki/ui/shared/posts/post_widget.dart";

class PlaceholderPostWidget extends StatelessWidget {
  final bool showPadding;

  const PlaceholderPostWidget({super.key, this.showPadding = true});

  @override
  Widget build(BuildContext context) {
    const showAvatar = true;
    const layout = PostWidgetLayout.normal;
    const leftPostContentInset = 8 + 48;

    const isExpanded = layout == PostWidgetLayout.expanded;
    const isWide = layout == PostWidgetLayout.wide;
    final outlineColor = Theme.of(context).colorScheme.outline;
    // final outlineTextStyle = outlineColor.textStyle;

    final children = [
      Row(
        children: [
          const _Text(60),
          const SizedBox(width: 8),
          _Text(150, color: outlineColor),
        ],
      ),
      Wrap(
        children: [
          for (var i = 0; i < Random(i).nextInt(90); i++) ...[
            _Text(Random(i).nextDouble() * 20 + 10),
            const SizedBox(width: 3),
          ],
        ],
      ),
    ];

    return Padding(
      padding: showPadding ? const EdgeInsets.all(8) : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!(isWide || isExpanded) && showAvatar) ...[
                AvatarWidget(
                  null,
                  size: 48,
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: children,
                ),
              ),
            ],
          ),
          if (isExpanded) const Divider(height: 25),
          if (isExpanded)
            OverflowBar(
              spacing: 16.0,
              overflowSpacing: 8.0,
              children: [
                // Text(
                //   DateFormat.yMMMMd(
                //     Localizations.localeOf(context).toString(),
                //   ).add_jm().format(_post.postedAt),
                //   style: outlineTextStyle,
                // ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: outlineColor,
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                      child: const SizedBox.square(dimension: 24),
                    ),
                    // const SizedBox(width: 3.0),
                    // Text(
                    //   _post.visibility!.toDisplayString(l10n),
                    //   style: outlineTextStyle,
                    // ),
                  ],
                ),
              ],
            ),
          if (isExpanded) const Divider(height: 25),
          // if (isExpanded) PostMetricBar(_post.metrics),
          if (true) ...[
            if (isExpanded)
              const Padding(
                padding: EdgeInsets.only(top: 12.0, bottom: 4.0),
                child: Divider(height: 1),
              ),
            Padding(
              padding: isExpanded || isWide
                  ? EdgeInsets.zero
                  : const EdgeInsets.only(left: leftPostContentInset - 8),
              child: _InteractionBar(),
            ),
          ],
        ],
      ),
    );
  }
}

class _InteractionBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Row();
  }
}

class _Text extends StatelessWidget {
  final double width;
  final Color? color;

  // ignore: unused_element
  const _Text(this.width, {this.color});

  @override
  Widget build(BuildContext context) {
    const padding = 2.0;
    final textStyle = DefaultTextStyle.of(context).style;
    final height = (textStyle.fontSize ?? 8) - padding * 2;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: padding),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color ?? textStyle.color,
          borderRadius: BorderRadius.circular(height),
        ),
        child: SizedBox(width: width, height: height),
      ),
    );
  }
}
