import 'package:kaiteki/fediverse/backends/mastodon/client.dart';
import 'package:kaiteki/fediverse/backends/mastodon/shared_adapter.dart';
import 'package:kaiteki/fediverse/model/instance.dart';

class MastodonAdapter extends SharedMastodonAdapter<MastodonClient> {
  factory MastodonAdapter({MastodonClient? client}) {
    return MastodonAdapter._(client ?? MastodonClient());
  }

  MastodonAdapter._(MastodonClient client) : super(client);

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
