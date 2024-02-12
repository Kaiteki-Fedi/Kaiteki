import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

void testJsonObjectDeserialization<T>(
  String path,
  T Function(Map<String, dynamic>) fromJson,
) {
  final file = File(path);

  test(file.uri.pathSegments.last, () async {
    final json = await file.readAsString();

    expect(() {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return fromJson(map);
    }, returnsNormally);
  });
}
