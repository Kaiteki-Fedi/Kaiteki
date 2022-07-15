import 'package:widgetbook/src/knobs/knobs_builder.dart';
import 'package:widgetbook/widgetbook.dart';

extension KnobBuilderExtensions on KnobsBuilder {
  T enumOptions<T extends Enum>({
    required List<T> values,
    required String label,
    String Function(T value)? generateLabel,
  }) {
    Option<T> createOption(T value) {
      return Option(
        label: generateLabel == null ? value.name : generateLabel(value),
        value: value,
      );
    }

    return options(label: label, options: values.map(createOption).toList());
  }
}
