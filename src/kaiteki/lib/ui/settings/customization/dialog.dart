import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/utils/extensions.dart";

class ThemeDialog extends StatefulWidget {
  final ThemeMode themeMode;

  const ThemeDialog(this.themeMode, {super.key});

  @override
  State<ThemeDialog> createState() => _ThemeDialogState();
}

class _ThemeDialogState extends State<ThemeDialog> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.themeMode;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.theme),
      contentPadding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final themeMode in ThemeMode.values)
            RadioListTile(
              groupValue: _themeMode,
              value: themeMode,
              title: Text(themeMode.getDisplayString(context.l10n)),
              onChanged: (value) => setState(() => _themeMode = value!),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.materialL10n.cancelButtonLabel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_themeMode),
          child: Text(context.l10n.applyButtonLabel),
        ),
      ],
    );
  }
}
