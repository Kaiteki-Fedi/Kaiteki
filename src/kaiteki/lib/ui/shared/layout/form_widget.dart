import "package:flutter/material.dart";
import "package:kaiteki/constants.dart" as consts;

typedef FormWidgetBuilder = Widget Function(
  BuildContext context,
  bool fillsPage,
);

/// A widget that automatically adjusts itself for certain resolutions
class FormWidget extends StatelessWidget {
  final FormWidgetBuilder builder;
  final double contentWidth;
  final double contentHeight;
  final EdgeInsets padding;

  const FormWidget({
    super.key,
    required this.builder,
    this.contentWidth = consts.defaultFormWidth,
    this.contentHeight = consts.defaultFormHeight,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 24.0,
      vertical: 64.0,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          return Center(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Container(
                width: contentWidth,
                height: contentHeight,
                padding: padding,
                child: builder.call(context, false),
              ),
            ),
          );
        }

        return Padding(
          padding: padding,
          child: builder.call(context, true),
        );
      },
    );
  }
}
