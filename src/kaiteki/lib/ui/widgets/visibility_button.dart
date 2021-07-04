import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/model/visibility.dart' as PostVisibility;

typedef VisibilityButtonCallback = void Function(PostVisibility.Visibility visibility);

/// A button that lets the user choose between post visibilities.
class VisibilityButton extends StatelessWidget {
  final PostVisibility.Visibility visibility;
  final VisibilityButtonCallback? callback;

  VisibilityButton({required this.visibility, this.callback});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PostVisibility.Visibility>(
      icon: Icon(visibility.toIconData()),
      onSelected: (choice) => callback?.call(choice),
      enabled: callback != null,
      tooltip: 'Change post scope',
      itemBuilder: (_) {
        return [
          for (var value in PostVisibility.Visibility.values)
            new PopupMenuItem(
              child: ListTile(
                title: Text(value.toHumanString()),
                leading: Icon(value.toIconData()),
                contentPadding: const EdgeInsets.all(0.0),
                selected: value == visibility,
              ),
              value: value,
            ),
        ];
      },
    );
  }
}