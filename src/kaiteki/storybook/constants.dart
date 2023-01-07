import 'package:kaiteki/fediverse/api_type.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

final apiTypeOptions = ApiType.values.map((e) {
  return Option(
    label: e.displayName,
    value: e,
  );
}).toList();
