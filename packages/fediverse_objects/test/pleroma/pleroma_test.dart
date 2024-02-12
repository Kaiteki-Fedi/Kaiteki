import 'package:fediverse_objects/mastodon_v1.dart' as v1;
import 'package:fediverse_objects/mastodon.dart';

import '../common.dart';

const kExamplesPath = "test/pleroma/examples";

void main() {
  testJsonObjectDeserialization(
    "$kExamplesPath/instance_1.json",
    v1.Instance.fromJson,
  );

  testJsonObjectDeserialization(
    "$kExamplesPath/preview_card_1.json",
    PreviewCard.fromJson,
  );

  testJsonObjectDeserialization(
    "$kExamplesPath/preview_card_2.json",
    PreviewCard.fromJson,
  );
}
