import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/model/visibility.dart' as k;

typedef VisibilityButtonCallback = void Function(k.Visibility visibility);

/// A button that lets the user choose between post visibilities.
class VisibilityButton extends StatelessWidget {
  final k.Visibility visibility;
  final VisibilityButtonCallback? callback;

  const VisibilityButton({
    required this.visibility,
    this.callback,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<k.Visibility>(
      icon: Icon(visibility.toIconData()),
      onSelected: (choice) => callback?.call(choice),
      enabled: callback != null,
      tooltip: 'Change post scope',
      itemBuilder: (_) {
        return [
          for (var value in k.Visibility.values)
            PopupMenuItem(
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
