import "package:flutter/material.dart";
import "package:kaiteki/constants.dart";

const double _maxDialogSize = 560.0;

typedef DynamicDialogContainerBuilder = Widget Function(
  BuildContext,
  bool fullscreen,
);

class DynamicDialogContainer extends StatelessWidget {
  const DynamicDialogContainer({
    super.key,
    required this.builder,
  });

  final DynamicDialogContainerBuilder builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fullscreen = constraints.maxWidth < _maxDialogSize ||
            constraints.maxHeight < _maxDialogSize;

        final borderRadius = getBorderRadius(fullscreen);
        const duration = Duration(milliseconds: 125);

        return SafeArea(
          child: Center(
            child: AnimatedContainer(
              constraints: getConstraints(context, constraints, fullscreen),
              duration: duration,
              curve: Curves.easeOutQuad,
              child: Padding(
                padding: fullscreen
                    ? MediaQuery.viewInsetsOf(context)
                    : EdgeInsets.zero,
                child: Material(
                  borderRadius: borderRadius,
                  animationDuration: duration,
                  clipBehavior: Clip.antiAlias,
                  elevation: 8.0,
                  child: builder.call(context, fullscreen),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  BorderRadius getBorderRadius(bool fullscreen) {
    if (fullscreen) {
      return BorderRadius.zero;
    } else {
      return BorderRadius.circular(6.0);
    }
  }

  BoxConstraints getConstraints(
    BuildContext context,
    BoxConstraints constraints,
    // ignore: avoid_positional_boolean_parameters
    bool fullscreen,
  ) {
    if (fullscreen) return constraints;

    const margin = 32 * 2;
    return kDialogConstraints.copyWith(
      maxHeight: constraints.maxHeight - margin,
    );
  }
}
