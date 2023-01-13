import "package:flutter/material.dart";

/// A button used to trigger asynchronous actions.
///
/// It disables itself and shows an indeterminate progress indicator while the [onPressed] future is running.
class AsyncButton extends StatefulWidget {
  final Future Function() onPressed;
  final Widget child;
  final AsyncButtonType type;

  const AsyncButton({
    super.key,
    required this.onPressed,
    required this.child,
    // TODO(Craftplacer): Make AsyncButtonType part of theme
    this.type = AsyncButtonType.leftCircular,
  });

  @override
  State<AsyncButton> createState() => _AsyncButtonState();
}

class _AsyncButtonState extends State<AsyncButton> {
  Future? _future;

  bool get _isFutureRunning => _future != null;

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case AsyncButtonType.replace:
        return buildReplace(context);
      case AsyncButtonType.bottomLinear:
        return buildBottomLinear(context);
      case AsyncButtonType.leftCircular:
        return buildLeftCircular(context);
    }
  }

  Widget buildReplace(BuildContext context) {
    const progressIndicator = SizedBox.square(
      dimension: 18,
      child: CircularProgressIndicator(strokeWidth: 3),
    );

    return ElevatedButton(
      onPressed: _isFutureRunning ? null : _onPressed,
      style: _isFutureRunning
          ? ElevatedButton.styleFrom(padding: EdgeInsets.zero)
          : null,
      child: _isFutureRunning ? progressIndicator : widget.child,
    );
  }

  Future<void> _onPressed() async {
    assert(
      _future == null,
      "onPressed was called but there was already a future waiting to complete",
    );

    final future = widget.onPressed();

    setState(() {
      _future = future;
    });

    // Update widget once Future has completed
    await future.then((_) => setState(() => _future = null));
  }

  Widget buildLeftCircular(BuildContext context) {
    return ElevatedButton(
      onPressed: _isFutureRunning ? null : _onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isFutureRunning)
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: SizedBox.square(
                dimension: 16,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
            ),
          widget.child,
        ],
      ),
    );
  }

  Widget buildBottomLinear(BuildContext context) {
    final button = ElevatedButton(
      onPressed: _isFutureRunning ? null : _onPressed,
      child: widget.child,
    );

    return Stack(
      children: [
        button,
        if (_isFutureRunning)
          Positioned.fill(
            child: ClipPath(
              clipper: _ButtonClipper(
                button.defaultStyleOf(context).shape?.resolve({}),
              ),
              child: const Align(
                alignment: Alignment.bottomCenter,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

enum AsyncButtonType {
  /// Replaces the child with a [CircularProgressIndicator].
  replace,

  /// Overlays a [LinearProgressIndicator] on the child.
  bottomLinear,

  /// Prepends the child with a [CircularProgressIndicator].
  leftCircular
}

class _ButtonClipper extends CustomClipper<Path> {
  final ShapeBorder? border;

  const _ButtonClipper(this.border);

  @override
  Path getClip(Size size) {
    if (border == null) {
      return Path();
    }

    return border!.getOuterPath(
      Rect.fromLTWH(0, 0, size.width, size.height),
    );
  }

  @override
  bool shouldReclip(covariant _ButtonClipper oldClipper) {
    return border == oldClipper.border;
  }
}
