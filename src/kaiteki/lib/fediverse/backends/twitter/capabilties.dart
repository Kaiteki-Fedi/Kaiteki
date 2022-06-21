import 'package:kaiteki/fediverse/capabilities.dart';
import 'package:kaiteki/fediverse/model/formatting.dart';

class TwitterCapabilities extends AdapterCapabilities {
  @override
  List<Formatting> get supportedFormattings {
    return List.unmodifiable([Formatting.plainText]);
  }

  @override
  bool get supportsScopes => false;

  const TwitterCapabilities();
}
