import "package:flutter/material.dart";

/// A [ListTile] that contains a [Slider] widget.
///
/// Inspired from Lawnchair.
class SliderListTile extends StatelessWidget {
  final Widget title;
  final Widget? leading;
  final double value;
  final double min;
  final double max;
  final String? label;
  final int? divisions;
  final ValueChanged<double>? onChanged;

  const SliderListTile({
    super.key,
    required this.title,
    required this.value,
    this.leading,
    this.min = 0.0,
    this.max = 1.0,
    this.label,
    this.divisions,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final leading = this.leading;
    final label = this.label;

    // Sliders and ListTiles combined have fucky-wucky margin/padding.
    return ListTile(
      leading: leading == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: leading,
            ),
      horizontalTitleGap: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: title,
      ),
      contentPadding: EdgeInsets.zero,
      subtitle: SliderTheme(
        data: const SliderThemeData(
          overlayShape: RoundSliderOverlayShape(overlayRadius: 20),
        ),
        child: Slider.adaptive(
          min: min,
          max: max,
          value: value,
          divisions: divisions,
          onChanged: onChanged,
          label: label,
        ),
      ),
    );
  }
}
