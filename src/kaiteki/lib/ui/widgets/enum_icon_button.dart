import 'package:flutter/material.dart';

typedef EnumButtonCallback<T> = void Function(T newValue);
typedef IconBuilder<T> = Widget Function(T value);
typedef TextBuilder<T> = Widget Function(T value);

// FIXME: Implement `splashRadius`, `PopupMenuButton` does not expose it.
class EnumIconButton<T> extends StatelessWidget {
  final EnumButtonCallback<T>? onChanged;
  final IconBuilder<T> iconBuilder;
  final TextBuilder<T> textBuilder;

  final String tooltip;
  final T value;
  final List<T>? values;

  const EnumIconButton({
    Key? key,
    this.onChanged,
    required this.tooltip,
    required this.iconBuilder,
    required this.textBuilder,
    required this.value,
    this.values,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      icon: iconBuilder.call(value),
      onSelected: (choice) => onChanged?.call(choice),
      enabled: values?.isNotEmpty == true,
      tooltip: tooltip,
      itemBuilder: _buildItems,
    );
  }

  List<PopupMenuEntry<T>> _buildItems(BuildContext context) {
    final canSelect = onChanged != null;

    return [
      for (T value in values!)
        PopupMenuItem<T>(
          child: ListTile(
            leading: iconBuilder.call(value),
            title: textBuilder.call(value),
            contentPadding: EdgeInsets.zero,
            selected: value == this.value,
            enabled: canSelect,
          ),
          value: value,
          enabled: canSelect,
        ),
    ];
  }
}
