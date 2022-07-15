import 'package:flutter/material.dart';
import 'package:kaiteki/constants.dart';

const double _maxDialogSize = 560.0;

typedef DynamicDialogContainerBuilder = Widget Function(
  BuildContext,
  bool fullscreen,
);

class DynamicDialogContainer extends StatelessWidget {
  const DynamicDialogContainer({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final DynamicDialogContainerBuilder builder;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final fullscreen = constraints.maxWidth < _maxDialogSize ||
              constraints.maxHeight < _maxDialogSize;

          final borderRadius = getBorderRadius(fullscreen);
          const duration = Duration(milliseconds: 125);

          return Center(
            child: AnimatedContainer(
              constraints: getConstraints(constraints, fullscreen),
              duration: duration,
              curve: Curves.easeOutQuad,
              child: Material(
                borderRadius: borderRadius,
                animationDuration: duration,
                clipBehavior: Clip.antiAlias,
                elevation: 8.0,
                child: builder.call(context, fullscreen),
              ),
            ),
          );
        },
      ),
    );
  }

  BorderRadius getBorderRadius(bool fullscreen) {
    if (fullscreen) {
      return BorderRadius.zero;
    } else {
      return BorderRadius.circular(6.0);
    }
  }

  BoxConstraints getConstraints(BoxConstraints constraints, bool fullscreen) {
    if (fullscreen) return constraints;

    const margin = 32 * 2;
    return dialogConstraints.copyWith(
      maxHeight: constraints.maxHeight - margin,
    );
  }
}
