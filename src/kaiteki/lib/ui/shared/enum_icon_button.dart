import 'package:flutter/material.dart';

typedef EnumButtonCallback<T> = void Function(T newValue);
typedef EnumWidgetBuilder<T> = Widget Function(BuildContext context, T value);

class EnumIconButton<T> extends StatelessWidget {
  final EnumButtonCallback<T>? onChanged;
  final EnumWidgetBuilder<T> iconBuilder;
  final EnumWidgetBuilder<T> textBuilder;
  final EnumWidgetBuilder<T>? subtitleBuilder;
  final double? splashRadius;
  final String tooltip;
  final T value;
  final List<T>? values;
  final bool? dense;
  final bool isThreeLine;

  const EnumIconButton({
    super.key,
    this.onChanged,
    required this.tooltip,
    required this.iconBuilder,
    required this.textBuilder,
    required this.value,
    this.subtitleBuilder,
    this.splashRadius,
    this.values,
    this.dense,
    this.isThreeLine = false,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      icon: iconBuilder.call(context, value),
      onSelected: (choice) => onChanged?.call(choice),
      enabled: values?.isNotEmpty == true,
      tooltip: tooltip,
      itemBuilder: _buildItems,
      splashRadius: splashRadius,
      offset: const Offset(-8, -12),
    );
  }

  List<PopupMenuEntry<T>> _buildItems(BuildContext context) {
    final canSelect = onChanged != null;

    return [
      for (T value in values!)
        PopupMenuItem<T>(
          value: value,
          enabled: canSelect,
          child: ListTile(
            leading: iconBuilder.call(context, value),
            title: textBuilder.call(context, value),
            contentPadding: EdgeInsets.zero,
            selected: value == this.value,
            enabled: canSelect,
            dense: dense,
            isThreeLine: isThreeLine,
            subtitle: subtitleBuilder?.call(context, value),
          ),
        ),
    ];
  }
}
