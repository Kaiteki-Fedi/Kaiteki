import 'dart:developer';

import 'package:kaiteki/fediverse/backends/pleroma/client.dart';
import 'package:test/test.dart';

void main() {
  late PleromaClient client;
  setUpAll(() => client = PleromaClient("lain.com"));
  test("fetch instance", () async {
    final instance = await client.getInstance();
    log(
      "We are testing on ${instance.uri} (${instance.title}), running Pleroma ${instance.version}.",
    );
  });
  test("fetch user profile", () async {
    final user = await client.getAccount("lain");
    log("${user.displayName} (@${user.username}) - ${_multiLineTrim(user.note)}");
  });
  test("fetch emojis", () async {
    final emoji = await client.getCustomEmojis();
    log("This instance has ${emoji.length} emojis");
  });
  test("fetch emoji packs", () async {
    final packs = await client.getEmojiPacks();
    log("This instance has ${packs.count} emoji packs");
  });
  test("fetch federated timeline", () async {
    final statuses = await client.getPublicTimeline();
    expect(statuses.length, greaterThan(0));
    log("Fetched ${statuses.length} status(es)");
  });
}

String? _multiLineTrim(String? input) {
  if (input == null) return null;
  return input.split("\n").map((l) => l.trim()).join(" ");
}
