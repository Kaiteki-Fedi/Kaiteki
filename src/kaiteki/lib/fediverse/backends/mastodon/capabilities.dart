import 'package:kaiteki/fediverse/capabilities.dart';
import 'package:kaiteki/fediverse/model/formatting.dart';

class MastodonCapabilities extends AdapterCapabilities {
  @override
  bool get supportsScopes => true;

  const MastodonCapabilities();

  @override
  List<Formatting> get supportedFormattings {
    return List.unmodifiable([Formatting.plainText]);
  }
}
