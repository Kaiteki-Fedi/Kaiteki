import 'package:fediverse_objects/misskey.dart';
import 'package:kaiteki_core/social.dart';

class MisskeyCapabilities extends AdapterCapabilities
    implements
        ChatSupportCapabilities,
        HashtagSupportCapabilities,
        ReactionSupportCapabilities {
  @override
  final Set<TimelineType> supportedTimelines;

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
  Set<Visibility> get supportedScopes {
    return const {
      Visibility.public,
      Visibility.followersOnly,
      Visibility.unlisted,
      Visibility.direct,
    };
  }

  @override
  bool get supportsChat => true;

  @override
  bool get supportsCustomEmojiReactions => true;

  @override
  bool get supportsFollowingHashtags => false;

  @override
  bool get supportsIndefinitePolls => true;

  @override
  bool get supportsMultipleReactions => false;

  @override
  bool get supportsSubjects => true;

  @override
  bool get supportsUnicodeEmojiReactions => true;
}
