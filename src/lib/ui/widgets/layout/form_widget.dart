import 'package:flutter/material.dart';


/// A widget that automatically adjusts itself for certain resolutions
class FormWidget extends StatelessWidget {
  final Widget child;
  final double contentWidth;
  final double contentHeight;
  final EdgeInsets padding;


  // TODO: mobile/portrait padding
  const FormWidget({
    Key key,
    @required this.child,
    this.contentWidth = 450,
    this.contentHeight = 600,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 24.0,
      vertical: 64.0,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (contentWidth <= constraints.maxWidth &&
            contentHeight <= constraints.maxHeight) {
          return Center(
            child: Card(
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
