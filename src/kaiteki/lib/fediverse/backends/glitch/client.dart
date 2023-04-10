import "package:kaiteki/fediverse/backends/mastodon/client.dart";
import "package:kaiteki/http/http.dart";

class GlitchClient extends MastodonClient {
  GlitchClient(super.instance);

  Future<void> react(String postId, String emoji) async {
    await client.sendRequest(
      HttpMethod.post,
      "/api/v1/statuses/$postId/react/$emoji",
    );
  }

  Future<void> removeReaction(String postId, String emoji) async {
    await client.sendRequest(
      HttpMethod.post,
      "/api/v1/statuses/$postId/unreact/$emoji",
    );
  }
}
