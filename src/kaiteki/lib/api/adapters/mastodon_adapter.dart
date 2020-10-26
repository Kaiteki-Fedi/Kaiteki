import 'package:kaiteki/api/adapters/shared_mastodon_adapter.dart';
import 'package:kaiteki/api/clients/mastodon_client.dart';

class MastodonAdapter extends SharedMastodonAdapter<MastodonClient> {
  MastodonAdapter._(MastodonClient client) : super(client);

  factory MastodonAdapter({MastodonClient client}) {
    return MastodonAdapter._(client ?? MastodonClient());
  }
}