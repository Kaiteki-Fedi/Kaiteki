import 'package:kaiteki/fediverse/capabilities.dart';
import 'package:kaiteki/fediverse/model/formatting.dart';

class MastodonCapabilities extends AdapterCapabilities {
  const MastodonCapabilities();

  @override
  bool get supportsScopes => true;

  @override
  bool get supportsSubjects => true;

  @override
  List<Formatting> get supportedFormattings {
    return List.unmodifiable([Formatting.plainText]);
  }
}
