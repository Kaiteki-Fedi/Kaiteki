import 'package:kaiteki/fediverse/capabilities.dart';

class MastodonCapabilities extends AdapterCapabilities {
  @override
  bool get supportsScopes => true;

  const MastodonCapabilities();
}
