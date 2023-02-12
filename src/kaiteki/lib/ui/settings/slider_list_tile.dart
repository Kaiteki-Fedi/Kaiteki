import "package:flutter/material.dart";

/// A [ListTile]-like [Widget] that wraps a [Slider] widget.
///
/// Inspired from Lawnchair.
class SliderListTile extends StatelessWidget {
  final Widget title;
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
    this.min = 0.0,
    this.max = 1.0,
    this.label,
    this.divisions,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final headlineTextStyle = Theme.of(context).textTheme.bodyLarge;
    final trailingSupportingTextStyle = Theme.of(context)
        .textTheme
        .bodyLarge
        ?.copyWith(color: Theme.of(context).colorScheme.outline);

    final label = this.label;
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                DefaultTextStyle.merge(
                  style: headlineTextStyle,
                  child: title,
                ),
                const Spacer(),
                if (label != null)
                  Text(
                    label,
                    style: trailingSupportingTextStyle,
                  ),
              ],
            ),
          ),
          SliderTheme(
            data: const SliderThemeData(
              overlayShape: RoundSliderOverlayShape(overlayRadius: 16),
            ),
            child: Slider.adaptive(
              min: min,
              max: max,
              value: value,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
