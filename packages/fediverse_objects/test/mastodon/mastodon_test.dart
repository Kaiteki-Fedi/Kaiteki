import 'dart:convert';

import 'package:fediverse_objects/mastodon.dart';
import 'package:fediverse_objects/mastodon_v1.dart' as v1;
import 'package:http/http.dart';
import 'package:test/test.dart';

import '../common.dart';

const kExamplesPath = "test/mastodon/examples";

final examples = [
  (Account, Account.fromJson, ["account"]),
  (Announcement, Announcement.fromJson, ["announcement"]),
  (CustomEmoji, CustomEmoji.fromJson, ["custom_emoji"]),
  (
    PreviewCard,
    PreviewCard.fromJson,
    [
      "preview_card_photo",
      "preview_card_link",
      "preview_card_video",
      "trends_link",
    ],
  ),
  (MediaAttachment, MediaAttachment.fromJson, ["media_attachment"]),
  (Status, Status.fromJson, ["status"]),
  (Tag, Tag.fromJson, ["tag"]),
  (Role, Role.fromJson, ["role"]),
];

void main() {
  const instance = "mastodon.social";

  group('Instance', () {
    test('v2', () async {
      final uri = Uri.https(instance, "/api/v2/instance");
      final response = await get(uri);

      final map = jsonDecode(response.body) as Map<String, dynamic>;
      expect(() => Instance.fromJson(map), returnsNormally);
    });

    test('v1', () async {
      final uri = Uri.https(instance, "/api/v1/instance");
      final response = await get(uri);

      final map = jsonDecode(response.body) as Map<String, dynamic>;
      expect(() => v1.Instance.fromJson(map), returnsNormally);
    });
  });

  for (final example in examples) {
    group(example.$1.toString(), () {
      for (final name in example.$3) {
        testJsonObjectDeserialization(
          "$kExamplesPath/$name.json",
          example.$2,
        );
      }
    });
  }

  group('Friendica', () {
    testJsonObjectDeserialization(
      "$kExamplesPath/friendica/instance.json",
      Instance.fromJson,
    );
    testJsonObjectDeserialization(
      "$kExamplesPath/friendica/status.json",
      Status.fromJson,
    );
  });
}
