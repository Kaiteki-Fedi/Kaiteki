import "package:flutter/material.dart";
import "package:kaiteki/ui/shared/posts/post_widget.dart";

import "source.dart";
import "timeline.dart";

class Timeline extends StatelessWidget {
  final double? maxWidth;
  final PostWidgetLayout? postLayout;
  final TimelineSource source;

  const Timeline(
    this.source, {
    super.key,
    this.maxWidth,
    this.postLayout,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        TimelineSliver(
          source,
          postLayout: postLayout,
        ),
      ],
    );
  }
}
