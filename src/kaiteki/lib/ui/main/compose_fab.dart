import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/utils/extensions.dart';

class ComposeFloatingActionButton extends StatelessWidget {
  final ComposeFloatingActionButtonType type;
  final bool elevate;

  const ComposeFloatingActionButton({
    Key? key,
    required this.type,
    this.elevate = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final elevation = elevate ? 4.0 : 0.0;
    const icon = Icon(Icons.edit_rounded);
    switch (type) {
      case ComposeFloatingActionButtonType.small:
        return FloatingActionButton.small(
          onPressed: () => context.showPostDialog(),
          elevation: elevation,
          child: icon,
        );
      case ComposeFloatingActionButtonType.normal:
        return FloatingActionButton(
          onPressed: () => context.showPostDialog(),
          elevation: elevation,
          child: icon,
        );
      case ComposeFloatingActionButtonType.extended:
        return SizedBox(
          height: 48,
          child: FloatingActionButton.extended(
            onPressed: () => context.showPostDialog(),
            elevation: elevation,
            label: Text(context.getL10n().composeButtonLabel),
            icon: icon,
          ),
        );
    }
  }
}

enum ComposeFloatingActionButtonType { small, normal, extended }
