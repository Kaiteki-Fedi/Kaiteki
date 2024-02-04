import "package:flutter/material.dart";

class SettingsContainer extends StatelessWidget {
  final Widget child;

  const SettingsContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: child,
      ),
    );
  }
}
