import 'package:flutter/material.dart';
import 'package:kaiteki/constants.dart';

/// A widget that automatically adjusts itself for certain resolutions
class FormWidget extends StatelessWidget {
  final Widget child;
  final double contentWidth;
  final double contentHeight;
  final EdgeInsets padding;

  const FormWidget({
    Key? key,
    required this.child,
    this.contentWidth = Constants.defaultFormWidth,
    this.contentHeight = Constants.defaultFormHeight,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 24.0,
      vertical: 64.0,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        if (orientation == Orientation.landscape) {
          return Center(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Container(
                width: contentWidth,
                height: contentHeight,
                padding: padding,
                child: child,
              ),
            ),
          );
        }

        return Padding(
          padding: padding,
          child: child,
        );
      },
    );
  }
}
