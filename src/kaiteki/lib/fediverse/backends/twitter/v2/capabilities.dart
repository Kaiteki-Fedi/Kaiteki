import "package:kaiteki/fediverse/capabilities.dart";
import "package:kaiteki/fediverse/model/formatting.dart";
import "package:kaiteki/fediverse/model/timeline_kind.dart";
import "package:kaiteki/fediverse/model/visibility.dart";

class TwitterCapabilities extends AdapterCapabilities {
  const TwitterCapabilities();

  @override
  Set<Formatting> get supportedFormattings => const {Formatting.plainText};

  @override
  Set<Visibility> get supportedScopes {
    return const {
      Visibility.public, /* Visibility.circle */
    };
  }

  @override
  bool get supportsSubjects => false;

  @override
  Set<TimelineKind> get supportedTimelines => const {TimelineKind.home};
}
