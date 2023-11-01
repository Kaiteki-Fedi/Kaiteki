import 'package:flutter/material.dart';

/// {@category Async}
/// A button used to trigger asynchronous actions.
///
/// It disables itself and shows an indeterminate progress indicator while the [onPressed] future is running.
class AsyncButton extends StatefulWidget {
  final Future Function()? onPressedFuture;
  final Stream<double?> Function()? onPressedStream;
  final Widget child;

  // TODO(Craftplacer): Make AsyncButtonType part of theme
  final AsyncButtonType type;

  const AsyncButton({
    super.key,
    required Future Function()? onPressed,
    required this.child,
    this.type = AsyncButtonType.leftCircular,
  })  : onPressedFuture = onPressed,
        onPressedStream = null;

  const AsyncButton.progress({
    super.key,
    required Stream<double> Function()? onPressed,
    required this.child,
    this.type = AsyncButtonType.leftCircular,
  })  : onPressedFuture = null,
        onPressedStream = onPressed;

  @override
  State<AsyncButton> createState() => _AsyncButtonState();
}

class _AsyncButtonState extends State<AsyncButton> {
  Future? _future;
  Stream<double?>? _stream;

  static const _strokeWidth = 3.0;

  bool get _isRunning => _future != null || _stream != null;

  @override
  Widget build(BuildContext context) {
    if (_future != null) {
      return FutureBuilder(
        future: _future,
        builder: (context, _) => _buildButton(context, null),
      );
    }

    if (_stream != null) {
      return StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          return _buildButton(context, snapshot.data);
        },
      );
    }

    return _buildButton(context, null);
  }

  Widget _buildButton(BuildContext context, double? progress) {
    switch (widget.type) {
      case AsyncButtonType.replace:
        return buildReplace(context, progress);

      case AsyncButtonType.bottomLinear:
        return buildBottomLinear(context, progress);

      case AsyncButtonType.leftCircular:
        return buildLeftCircular(context, progress);
    }
  }

  Widget buildReplace(BuildContext context, double? progress) {
    final progressIndicator = SizedBox.square(
      dimension: 18,
      child: CircularProgressIndicator(
        strokeWidth: _strokeWidth,
        value: progress,
      ),
    );

    return ElevatedButton(
      onPressed: _isRunning ? null : _onPressed,
      style: _isRunning
          ? ElevatedButton.styleFrom(padding: EdgeInsets.zero)
          : null,
      child: _isRunning ? progressIndicator : widget.child,
    );
  }

  Future<void> _onPressed() async {
    assert(
      !_isRunning,
      "onPressed was called but there was already a future waiting to complete",
    );

    final futureCallback = widget.onPressedFuture;
    final streamCallback = widget.onPressedStream;
    if (futureCallback != null) {
      final future = futureCallback();

      setState(() {
        _future = future;
      });

      // Update widget once Future has completed
      await future.then((_) => setState(() => _future = null));
    } else if (streamCallback != null) {
      final stream = streamCallback().asBroadcastStream();

      setState(() {
        _stream = stream;
      });

      // Update widget once Future has completed
      stream.listen(
        null,
        onDone: () => setState(() => _stream = null),
      );
    }
  }

  Widget buildLeftCircular(BuildContext context, double? progress) {
    return ElevatedButton(
      onPressed: _isRunning ? null : _onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isRunning)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: SizedBox.square(
                dimension: 16,
                child: CircularProgressIndicator(
                  strokeWidth: _strokeWidth,
                  value: progress,
                ),
              ),
            ),
          widget.child,
        ],
      ),
    );
  }

  Widget buildBottomLinear(BuildContext context, double? progress) {
    final button = ElevatedButton(
      onPressed: _isRunning ? null : _onPressed,
      child: widget.child,
    );

    return Stack(
      children: [
        button,
        if (_isRunning)
          Positioned.fill(
            child: ClipPath(
              clipper: _ButtonClipper(
                button.defaultStyleOf(context).shape?.resolve({}),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                  value: progress,
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
