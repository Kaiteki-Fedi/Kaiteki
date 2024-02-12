import 'package:kaiteki_core/social.dart';

class TumblrCapabilities extends AdapterCapabilities {
  const TumblrCapabilities();

  @override
  Set<PostScope> get supportedScopes => const {PostScope.public};

  @override
  bool get supportsSubjects => true;

  @override
  Set<Formatting> get supportedFormattings {
    return const {Formatting.plainText, Formatting.markdown};
  }

  @override
  Set<TimelineType> get supportedTimelines => const {TimelineType.following};
}
