import "package:flutter/material.dart";
import "package:kaiteki/ui/adaptive_menu_anchor.dart";

typedef EnumButtonCallback<T> = void Function(T newValue);
typedef EnumWidgetBuilder<T> = Widget Function(BuildContext context, T value);

class EnumIconButton<T> extends StatelessWidget {
  final EnumButtonCallback<T>? onChanged;
  final EnumWidgetBuilder<T> iconBuilder;
  final EnumWidgetBuilder<T> textBuilder;
  @Deprecated("Not supported anymore.")
  final EnumWidgetBuilder<T>? subtitleBuilder;
  final double? splashRadius;
  final String tooltip;
  final T value;
  final Set<T>? values;
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
    return AdaptiveMenu(
      key: key,
      builder: (context, onPressed) {
        return IconButton(
          icon: iconBuilder.call(context, value),
          onPressed: onPressed,
          tooltip: tooltip,
          splashRadius: splashRadius,
        );
      },
      itemBuilder: _buildItems,
    );
  }

  List<MenuItemButton> _buildItems(
    BuildContext context,
    VoidCallback? onClose,
  ) {
    final canSelect = onChanged != null;

    return [
      for (final value in values!)
        MenuItemButton(
          onPressed: canSelect
              ? () {
                  onChanged?.call(value);
                  onClose?.call();
                }
              : null,
          leadingIcon: iconBuilder.call(context, value),
          trailingIcon: value == this.value
              ? const Icon(Icons.check_rounded)
              : const SizedBox.square(dimension: 24),
          child: textBuilder.call(context, value),
        ),
    ];
  }
}
