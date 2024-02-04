import "package:kaiteki_core/backends/misskey.dart";
import "package:kaiteki_core/kaiteki_core.dart";

const kKaiteki = "9euqrmxo24";

class DemoAdapter extends MisskeyAdapter {
  DemoAdapter(super.type, super.client, super.capabilities) {
    authenticated = true;
  }

  static Future<DemoAdapter> create(ApiType type, String instance) async {
    final client = MisskeyClient(instance);
    final meta = await client.getMeta();
    return DemoAdapter(
      type,
      client,
      MisskeyCapabilities.fromMeta(meta),
    );
  }

  @override
  Future<List<Post>> getTimeline(
    TimelineType type, {
    TimelineQuery<String>? query,
    PostFilter? filter,
  }) async =>
      getPostsOfUserById(kKaiteki);
}
