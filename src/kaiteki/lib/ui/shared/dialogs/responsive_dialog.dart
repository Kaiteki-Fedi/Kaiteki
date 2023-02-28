import "package:flutter/material.dart";

const double _maxDialogSize = 560.0;

typedef ResponsiveDialogBuilder = Widget Function(
  BuildContext,
  bool fullscreen,
);

class ResponsiveDialog extends StatelessWidget {
  const ResponsiveDialog({
    super.key,
    required this.builder,
  });

  final ResponsiveDialogBuilder builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fullscreen = constraints.maxWidth < _maxDialogSize ||
            constraints.maxHeight < _maxDialogSize;

        final child = builder.call(context, fullscreen);

        if (fullscreen) {
          return Dialog.fullscreen(child: child);
        }
        return Dialog(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: _maxDialogSize,
            ),
            child: child,
          ),
        );
      },
    );
  }
}
