import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';

class ComposeFloatingActionButton extends StatelessWidget {
  final ComposeFloatingActionButtonType type;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback onTap;

  const ComposeFloatingActionButton({
    super.key,
    required this.type,
    required this.onTap,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final elevation = Theme.of(context).useMaterial3 ? 0.0 : null;
    const icon = Icon(Icons.edit_rounded);
    switch (type) {
      case ComposeFloatingActionButtonType.small:
        return FloatingActionButton.small(
          onPressed: onTap,
          elevation: elevation,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          child: icon,
        );
      case ComposeFloatingActionButtonType.normal:
        return FloatingActionButton(
          onPressed: onTap,
          elevation: elevation,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          child: icon,
        );
      case ComposeFloatingActionButtonType.extended:
        return SizedBox(
          height: 48,
          child: FloatingActionButton.extended(
            onPressed: onTap,
            elevation: elevation,
            label: Text(context.l10n.composeButtonLabel),
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            icon: icon,
          ),
        );
    }
  }
}

enum ComposeFloatingActionButtonType { small, normal, extended }
