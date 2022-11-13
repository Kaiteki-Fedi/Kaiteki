import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/utils/extensions.dart';

class ComposeFloatingActionButton extends StatelessWidget {
  final ComposeFloatingActionButtonType type;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const ComposeFloatingActionButton({
    super.key,
    required this.type,
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
          onPressed: () => context.showPostDialog(),
          elevation: elevation,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          child: icon,
        );
      case ComposeFloatingActionButtonType.normal:
        return FloatingActionButton(
          onPressed: () => context.showPostDialog(),
          elevation: elevation,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          child: icon,
        );
      case ComposeFloatingActionButtonType.extended:
        return SizedBox(
          height: 48,
          child: FloatingActionButton.extended(
            onPressed: () => context.showPostDialog(),
            elevation: elevation,
            label: Text(context.getL10n().composeButtonLabel),
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            icon: icon,
          ),
        );
    }
  }
}

enum ComposeFloatingActionButtonType { small, normal, extended }
