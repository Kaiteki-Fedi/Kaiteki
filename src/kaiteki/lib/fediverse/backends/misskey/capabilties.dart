import 'package:kaiteki/fediverse/capabilities.dart';
import 'package:kaiteki/fediverse/interfaces/reaction_support.dart';
import 'package:kaiteki/fediverse/model/formatting.dart';

class MisskeyCapabilities extends AdapterCapabilities
    implements ReactionSupportCapabilities {
  @override
  bool get supportsCustomEmojiReactions => true;

  @override
  bool get supportsScopes => true;

  @override
  bool get supportsUnicodeEmojiReactions => true;

  const MisskeyCapabilities();

  @override
  List<Formatting> get supportedFormattings {
    return List.unmodifiable([Formatting.misskeyMarkdown]);
  }

  @override
  bool get supportsSubjects => true;
}
