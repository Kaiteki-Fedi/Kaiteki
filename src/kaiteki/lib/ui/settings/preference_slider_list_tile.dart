import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:kaiteki/ui/settings/slider_list_tile.dart";
import "package:notified_preferences/notified_preferences.dart";

String _defaultLabelBuilder(double value) => value.toString();

class PreferenceSliderListTile extends ConsumerWidget {
  final ChangeNotifierProvider<PreferenceNotifier<double>> provider;
  final Widget title;
  final String Function(double value) labelBuilder;
  final double min;
  final double max;
  final int? divisions;
  final List<double>? values;

  const PreferenceSliderListTile({
    super.key,
    required this.provider,
    required this.title,
    this.labelBuilder = _defaultLabelBuilder,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
  }) : values = null;

  const PreferenceSliderListTile.values({
    super.key,
    required this.provider,
    required this.title,
    required List<double> this.values,
    this.labelBuilder = _defaultLabelBuilder,
  })  : divisions = values.length - 1,
        min = 0,
        max = values.length - 1.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(provider).value;
    final values = this.values;

    return SliderListTile(
      title: title,
      onChanged: (value) => ref.read(provider).value = _getActualValue(value),
      value: (values == null ? value : values.indexOf(value).toDouble())
          .clamp(min, max),
      min: min,
      max: max,
      label: labelBuilder(value),
      divisions: divisions,
    );
  }

  double _getActualValue(double index) {
    final values = this.values;

    if (values == null) return index;

    return values[index.round()];
  }
}
