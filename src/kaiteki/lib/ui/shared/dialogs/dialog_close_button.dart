import 'package:flutter/material.dart';

class DialogCloseButton extends StatelessWidget {
  final String? tooltip;

  const DialogCloseButton({super.key, this.tooltip});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.close),
      tooltip: tooltip,
      onPressed: () => Navigator.of(context).maybePop(),
    );
  }
}
