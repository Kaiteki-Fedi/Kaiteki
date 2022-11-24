import 'package:kaiteki/fediverse/capabilities.dart';
import 'package:kaiteki/fediverse/interfaces/reaction_support.dart';
import 'package:kaiteki/fediverse/model/formatting.dart';
import 'package:kaiteki/fediverse/model/timeline_kind.dart';
import 'package:kaiteki/fediverse/model/visibility.dart';

class MisskeyCapabilities extends AdapterCapabilities
    implements ReactionSupportCapabilities {
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

  const MisskeyCapabilities();

  @override
  Set<Formatting> get supportedFormattings {
    return const {Formatting.misskeyMarkdown};
  }

  @override
  bool get supportsSubjects => true;

  @override
  Set<TimelineKind> get supportedTimelines => const {TimelineKind.home};

  @override
  bool get supportsMultipleReactions => false;
}
