import 'package:kaiteki_core/social.dart';

class MastodonCapabilities extends AdapterCapabilities
    implements
        HashtagSupportCapabilities,
        ExploreCapabilities,
        ReportCapabilities {
  const MastodonCapabilities();

  @override
  Set<Formatting> get supportedFormattings => const {Formatting.plainText};

  @override
  Set<PostScope> get supportedScopes {
    return const {
      PostScope.public,
      PostScope.followersOnly,
      PostScope.unlisted,
      PostScope.direct,
    };
  }

  @override
  Set<TimelineType> get supportedTimelines {
    return const {
      TimelineType.following,
      TimelineType.local,
      TimelineType.federated,
      TimelineType.directMessages,
    };
  }

  @override
  bool get supportsFollowingHashtags => true;

  @override
  bool get supportsLanguageTagging => true;

  @override
  bool get supportsSubjects => true;

  @override
  bool get supportsTrendingLinks => true;

  @override
  bool get canForwardReportsToRemoteInstances => true;

  @override
  bool get canIncludePosts => true;

  // https://github.com/mastodon/mastodon/blob/main/app/models/report.rb#L49
  @override
  int? get reportCommentLengthLimit => 1000;
}
