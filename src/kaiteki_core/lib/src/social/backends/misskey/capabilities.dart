import 'package:fediverse_objects/misskey.dart';
import 'package:kaiteki_core/social.dart';

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
        TimelineType.following,
        if (meta.disableLocalTimeline != true) TimelineType.local,
        if (meta.disableRecommendedTimeline == false) TimelineType.recommended,
        TimelineType.hybrid,
        if (meta.disableGlobalTimeline != true) TimelineType.federated,
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
  final Set<TimelineType> supportedTimelines;

  @override
  bool get supportsMultipleReactions => false;

  @override
  bool get supportsChat => true;
}
