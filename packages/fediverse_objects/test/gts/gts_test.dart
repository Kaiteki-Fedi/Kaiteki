import 'dart:convert';

import 'package:fediverse_objects/mastodon.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';

const kExamplesPath = "test/gts/examples";

void main() {
  const instance = "gts.superseriousbusiness.org";

  test('Instance (v2)', () async {
    final uri = Uri.https(instance, "/api/v2/instance");
    final response = await get(uri);

    final map = jsonDecode(response.body) as Map<String, dynamic>;
    expect(() => Instance.fromJson(map), returnsNormally);
  });
}
