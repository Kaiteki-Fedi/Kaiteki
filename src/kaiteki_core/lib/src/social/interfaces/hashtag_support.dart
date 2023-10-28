import 'dart:async';

import 'package:kaiteki_core/social.dart';

abstract class HashtagSupport {
  HashtagSupportCapabilities get capabilities;

  Future<void> followHashtag(String hashtag);

  Future<void> unfollowHashtag(String hashtag);

  Future<List<Post>> getPostsByHashtag(
    String hashtag, {
    TimelineQuery<String>? query,
  });

  FutureOr<Hashtag> getHashtag(String hashtag);
}

abstract class HashtagSupportCapabilities extends AdapterCapabilities {
  bool get supportsFollowingHashtags;

  const HashtagSupportCapabilities();
}
