import 'package:kaiteki/fediverse/api/adapters/mastodon/shared_adapter.dart';
import 'package:kaiteki/fediverse/api/clients/mastodon_client.dart';
import 'package:kaiteki/fediverse/model/instance.dart';

class MastodonAdapter extends SharedMastodonAdapter<MastodonClient> {
  MastodonAdapter._(MastodonClient client) : super(client);

  factory MastodonAdapter({MastodonClient? client}) {
    return MastodonAdapter._(client ?? MastodonClient());
  }

  @override
  Future<Instance?> probeInstance() async {
    final instance = await client.getInstance();
    if (instance.version.contains("Pleroma")) {
      return null;
    }

    return toInstance(instance);
  }

  @override
  Future<Instance> getInstance() async {
    return toInstance(await client.getInstance());
  }
}
