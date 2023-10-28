import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/utils/extensions.dart";

typedef ThemeDialogOptions = ({ThemeMode themeMode, bool useMaterial3});

class ThemeDialog extends StatefulWidget {
  final ThemeDialogOptions options;

  const ThemeDialog(this.options, {super.key});

  @override
  State<ThemeDialog> createState() => _ThemeDialogState();
}

class _ThemeDialogState extends State<ThemeDialog> {
  late ThemeMode _themeMode;
  late bool _useMaterial3;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.options.themeMode;
    _useMaterial3 = widget.options.useMaterial3;
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
          const Divider(height: 1 + 8 * 2),
          SwitchListTile(
            value: _useMaterial3,
            onChanged: (value) => setState(() => _useMaterial3 = value!),
            title: Text(context.l10n.useMaterialYou),
            contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.materialL10n.cancelButtonLabel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(
            (
              themeMode: _themeMode,
              useMaterial3: _useMaterial3,
            ),
          ),
          child: Text(context.l10n.applyButtonLabel),
        ),
      ],
    );
  }
}
