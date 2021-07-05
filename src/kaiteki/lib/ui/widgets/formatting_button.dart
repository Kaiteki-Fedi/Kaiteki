import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/model/formatting.dart';

typedef FormattingButtonCallback = void Function(Formatting formatting);

/// A button that lets the user choose between post formattings.
class FormattingButton extends StatelessWidget {
  final Formatting formatting;
  final FormattingButtonCallback? callback;

  const FormattingButton({
    required this.formatting,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Formatting>(
      icon: Icon(formatting.toIconData()),
      onSelected: (choice) => callback?.call(choice),
      enabled: callback != null,
      tooltip: 'Change formatting',
      itemBuilder: (_) {
        return [
          for (var value in Formatting.values)
            PopupMenuItem(
              child: ListTile(
                title: Text(value.toHumanString()),
                leading: Icon(value.toIconData()),
                contentPadding: const EdgeInsets.all(0.0),
                selected: value == formatting,
              ),
              value: value,
            ),
        ];
      },
    );
  }
}
