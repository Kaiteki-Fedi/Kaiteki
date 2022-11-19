import 'package:flutter/widgets.dart';

extension NullableStringExtensions on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  bool equalsIgnoreCase(String? other) {
    return this?.toLowerCase() == other?.toLowerCase();
  }
}

extension StringExtension on String {
  String get snake {
    final buffer = StringBuffer();

    for (final char in characters) {
      final isUppercase = char == char.toUpperCase();
      if (isUppercase) {
        buffer
          ..write("_")
          ..write(char.toLowerCase());
      } else {
        buffer.write(char);
      }
    }

    return buffer.toString();
  }
}
