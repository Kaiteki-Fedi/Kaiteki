import 'package:flutter/material.dart';

/// A button used to trigger asynchronous actions.
///
/// It disables itself and shows an indeterminate progress indicator while the [onPressed] future is running.
class AsyncButton extends StatefulWidget {
  final Future Function() onPressed;
  final Widget child;

  const AsyncButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  State<AsyncButton> createState() => _AsyncButtonState();
}

class _AsyncButtonState extends State<AsyncButton> {
  Future? _future;

  @override
  Widget build(BuildContext context) {
    final isFutureRunning = _future != null;
    final button = ElevatedButton(
      onPressed: isFutureRunning ? null : _onPressed,
      child: widget.child,
    );

    return Stack(
      children: [
        button,
        if (isFutureRunning)
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

    // if (_future == null) {
    //   return ElevatedButton(
    //     onPressed: _onPressed,
    //     child: widget.child,
    //   );
    // }
    //
    // return ElevatedButton.icon(
    //   icon: const Padding(
    //     padding: EdgeInsets.only(right: 4.0),
    //     child: SizedBox.square(
    //       dimension: 18,
    //       child: CircularProgressIndicator(
    //         strokeWidth: 3,
    //       ),
    //     ),
    //   ),
    //   onPressed: null,
    //   label: widget.child,
    // );
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
