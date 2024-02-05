import 'package:kaiteki_core/http.dart';
import 'package:kaiteki_core_backends/mastodon.dart';

class GlitchClient extends MastodonClient {
  GlitchClient(super.instance);

  Future<void> react(String postId, String emoji) async {
    await client.sendRequest(
      HttpMethod.post,
      '/api/v1/statuses/$postId/react/$emoji',
    );
  }

  Future<void> removeReaction(String postId, String emoji) async {
    await client.sendRequest(
      HttpMethod.post,
      '/api/v1/statuses/$postId/unreact/$emoji',
    );
  }
}
