import "package:kaiteki_core/kaiteki_core.dart";
import "package:kaiteki_core_backends/misskey.dart";

const kKaiteki = "9euqrmxo24";

class DemoAdapter extends MisskeyAdapter {
  DemoAdapter(super.client, super.capabilities) {
    authenticated = true;
  }

  static Future<DemoAdapter> create(BackendType type, String instance) async {
    final client = MisskeyClient(instance);
    final meta = await client.getMeta();
    final capabilities = MisskeyCapabilities.fromMeta(meta);
    return DemoAdapter(
      client,
      capabilities,
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
