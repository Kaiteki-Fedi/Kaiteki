import "package:kaiteki/fediverse/capabilities.dart";
import "package:kaiteki/fediverse/interfaces/explore_support.dart";
import "package:kaiteki/fediverse/model/formatting.dart";
import "package:kaiteki/fediverse/model/timeline_kind.dart";
import "package:kaiteki/fediverse/model/visibility.dart";

class MastodonCapabilities extends AdapterCapabilities
    implements ExploreCapabilities {
  const MastodonCapabilities();

  @override
  Set<Visibility> get supportedScopes {
    return const {
      Visibility.public,
      Visibility.followersOnly,
      Visibility.unlisted,
      Visibility.direct,
    };
  }

  @override
  bool get supportsSubjects => true;

  @override
  Set<Formatting> get supportedFormattings => const {Formatting.plainText};

  @override
  Set<TimelineKind> get supportedTimelines {
    return const {
      TimelineKind.home,
      TimelineKind.local,
      TimelineKind.federated,
      TimelineKind.directMessages,
    };
  }

  @override
  bool get supportsLanguageTagging => true;

  @override
  bool get supportsTrendingLinks => true;
}
