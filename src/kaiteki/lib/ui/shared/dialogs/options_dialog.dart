import "package:flutter/material.dart";
import "package:kaiteki/ui/settings/preference_values_list_tile.dart";

class OptionsDialog<T> extends StatefulWidget {
  final Widget? title;
  final T groupValue;
  final List<T> values;
  final Widget Function(BuildContext context, T value)? textBuilder;

  const OptionsDialog({
    super.key,
    required this.groupValue,
    required this.values,
    required this.textBuilder,
    this.title,
  });

  factory OptionsDialog.fromListTile(
    PreferenceValuesListTile<T> widget,
    T value,
  ) {
    return OptionsDialog(
      groupValue: value,
      textBuilder: widget.textBuilder,
      values: widget.values!,
      title: widget.title,
    );
  }

  @override
  State<OptionsDialog<T>> createState() => _OptionsDialogState<T>();
}

class _OptionsDialogState<T> extends State<OptionsDialog<T>> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title,
      contentPadding: EdgeInsets.only(
        top: Theme.of(context).useMaterial3 ? 16 : 20,
        bottom: 24,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final value in widget.values)
            RadioListTile(
              title: (widget.textBuilder ?? defaultTextBuilder)(context, value),
              onChanged: (value) => Navigator.of(context).maybePop(value),
              groupValue: widget.groupValue,
              value: value,
            ),
        ],
      ),
    );
  }
}
