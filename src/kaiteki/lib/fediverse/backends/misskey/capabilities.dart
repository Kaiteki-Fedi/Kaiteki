import "package:fediverse_objects/misskey.dart";
import "package:kaiteki/fediverse/capabilities.dart";
import "package:kaiteki/fediverse/interfaces/chat_support.dart";
import "package:kaiteki/fediverse/interfaces/reaction_support.dart";
import "package:kaiteki/fediverse/model/formatting.dart";
import "package:kaiteki/fediverse/model/timeline_kind.dart";
import "package:kaiteki/fediverse/model/visibility.dart";

class MisskeyCapabilities extends AdapterCapabilities
    implements ReactionSupportCapabilities, ChatSupportCapabilities {
  @override
  bool get supportsCustomEmojiReactions => true;

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
  bool get supportsUnicodeEmojiReactions => true;

  const MisskeyCapabilities({
    required this.supportedTimelines,
  });

  factory MisskeyCapabilities.fromMeta(Meta meta) {
    return MisskeyCapabilities(
      supportedTimelines: {
        TimelineKind.home,
        if (meta.disableLocalTimeline != true) TimelineKind.local,
        if (meta.disableRecommendedTimeline == false) TimelineKind.recommended,
        TimelineKind.hybrid,
        if (meta.disableGlobalTimeline != true) TimelineKind.federated,
      },
    );
  }

  @override
  Set<Formatting> get supportedFormattings {
    return const {Formatting.misskeyMarkdown};
  }

  @override
  bool get supportsSubjects => true;

  @override
  final Set<TimelineKind> supportedTimelines;

  @override
  bool get supportsMultipleReactions => false;

  @override
  bool get supportsChat => true;
}
