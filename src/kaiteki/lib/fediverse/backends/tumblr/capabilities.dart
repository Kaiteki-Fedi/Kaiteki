import "package:kaiteki/fediverse/capabilities.dart";
import "package:kaiteki/fediverse/model/formatting.dart";
import "package:kaiteki/fediverse/model/timeline_kind.dart";
import "package:kaiteki/fediverse/model/visibility.dart";

class TumblrCapabilities extends AdapterCapabilities {
  const TumblrCapabilities();

  @override
  Set<Visibility> get supportedScopes => const {Visibility.public};

  @override
  bool get supportsSubjects => true;

  @override
  Set<Formatting> get supportedFormattings {
    return const {Formatting.plainText, Formatting.markdown};
  }

  @override
  Set<TimelineKind> get supportedTimelines => const {TimelineKind.home};
}
