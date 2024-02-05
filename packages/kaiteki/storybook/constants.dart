import "package:kaiteki_core_backends/kaiteki_core_backends.dart";
import "package:storybook_flutter/storybook_flutter.dart";

final apiTypeOptions = BackendType.values.map((e) {
  return Option(
    label: e.name,
    value: e,
  );
}).toList();
