import 'package:kaiteki/fediverse/api/adapters/mastodon/shared_adapter.dart';
import 'package:kaiteki/fediverse/api/clients/mastodon_client.dart';

class MastodonAdapter extends SharedMastodonAdapter<MastodonClient> {
  MastodonAdapter._(MastodonClient client) : super(client);

  factory MastodonAdapter({MastodonClient? client}) {
    return MastodonAdapter._(client ?? MastodonClient());
  }
}
