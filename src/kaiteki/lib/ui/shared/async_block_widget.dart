import 'package:flutter/widgets.dart';

/// Widget that obscures its child widget to indicate a blocking asynchronous
/// operations.
class AsyncBlockWidget extends StatelessWidget {
  final bool blocking;

  /// Opacity used while blocking
  final double opacity;

  final Widget child;

  /// [Widget] that will be displayed while [blocking].
  final Widget? secondChild;

  final Duration duration;

  const AsyncBlockWidget({
    Key? key,
    required this.child,
    required this.duration,
    this.blocking = false,
    this.opacity = .125,
    this.secondChild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final secondChild = this.secondChild;

    return Stack(
      children: [
        AnimatedOpacity(
          opacity: blocking ? opacity : 1.0,
          duration: duration,
          child: AbsorbPointer(
            absorbing: blocking,
            child: Focus(
              canRequestFocus: false,
              descendantsAreFocusable: !blocking,
              child: child,
            ),
          ),
        ),
        if (blocking && secondChild != null)
          Positioned.fill(child: secondChild),
      ],
    );
  }
}
