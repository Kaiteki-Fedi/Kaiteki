import "dart:developer";

import "package:collection/collection.dart";
import "package:kaiteki/fediverse/backends/twitter/v2/model/media.dart" as twt;
import "package:kaiteki/fediverse/backends/twitter/v2/model/media.dart";
import "package:kaiteki/fediverse/backends/twitter/v2/model/tweet.dart" as twt;
import "package:kaiteki/fediverse/backends/twitter/v2/model/user.dart" as twt;
import "package:kaiteki/fediverse/backends/twitter/v2/responses/response.dart";
import "package:kaiteki/fediverse/model/model.dart" as ktk;
import "package:kaiteki/fediverse/model/model.dart";
import "package:kaiteki/utils/extensions.dart";

extension UserExtensions on twt.User {
  ktk.User toKaiteki() {
    return ktk.User(
      source: this,
      id: id,
      username: username,
      displayName: name,
      host: "twitter.com",
      avatarUrl: profileImageUrl.nullTransform(Uri.parse),
      joinDate: createdAt,
      description: description,
      details: ktk.UserDetails(
        location: location,
        website: url,
      ),
      url: Uri(
        scheme: "https",
        host: "twitter.com",
        pathSegments: [username],
      ),
      metrics: publicMetrics?.toKaiteki() ?? const ktk.UserMetrics(),
    );
  }
}

extension UserMetricsExtensions on twt.UserPublicMetrics {
  ktk.UserMetrics toKaiteki() {
    return ktk.UserMetrics(
      followerCount: followersCount,
      followingCount: followingCount,
      postCount: tweetCount,
    );
  }
}

extension TweetExtensions on twt.Tweet {
  ktk.Post toKaiteki(ResponseIncludes includes) {
    (String id, twt.Tweet?)? getTweet(twt.ReferencedTweetType type) {
      final id = referencedTweets?.firstWhereOrNull((t) => t.type == type)?.id;

      if (id == null) return null;

      return (
        id,
        includes.tweets?.firstWhereOrNull((t) => t.id == id),
      );
    }

    final retweet = getTweet(twt.ReferencedTweetType.retweeted);
    final quote = getTweet(twt.ReferencedTweetType.quoted);
    final op = getTweet(twt.ReferencedTweetType.repliedTo);

    final media = attachments?.mediaKeys
        ?.map((key) {
          return includes.media?.firstWhereOrNull((m) => m.mediaKey == key);
        })
        .where((m) => m != null)
        .cast<Media>();

    final author = includes.users!.firstWhere((u) => u.id == authorId);

    final replyTo = op.nullTransform(
      (op) => ResolvablePost(op.$1, op.$2?.toKaiteki(includes)),
    );

    return ktk.Post(
      source: this,
      id: id,
      author: author.toKaiteki(),
      postedAt: createdAt!,
      content: getText(),
      language: lang,
      repeatOf: retweet?.$2.nullTransform((t) => t.toKaiteki(includes)),
      quotedPost: quote?.$2.nullTransform((t) => t.toKaiteki(includes)),
      attachments: media
          ?.where((m) {
            final hasUrl = m.url != null || m.previewImageUrl != null;
            if (!hasUrl) log("Media (${m.mediaKey}) has no URL");
            return hasUrl;
          })
          .map((m) => m.toKaiteki())
          .toList(),
      replyTo: replyTo,
      metrics: PostMetrics(
        favoriteCount: publicMetrics?.likeCount ?? 0,
        repeatCount: (publicMetrics?.retweetCount ?? 0) +
            (publicMetrics?.quoteCount ?? 0),
        replyCount: publicMetrics?.replyCount ?? 0,
      ),
      replyToUser: replyTo?.data == null
          ? inReplyToUserId.nullTransform(ResolvableUser.fromId)
          : ResolvableUser.fromData(replyTo!.data!.author),
      externalUrl: Uri(
        scheme: "https",
        host: "twitter.com",
        pathSegments: [author.username, "status", id],
      ),
      client: source,
      // TODO(Craftplacer): I said they don't look nice enough, filter out like tweet text
      // embeds: entities?.urls?.map((u) => u.toKaiteki()).toList() ?? [],
    );
  }

  String getText() {
    final entities = this.entities;

    if (entities == null) return text;

    final buffer = StringBuffer();

    final entityMap = <int, twt.TweetEntity>{
      if (entities.urls != null)
        for (final e in entities.urls!) e.start: e
    };

    for (var i = 0; i < text.length;) {
      final entity = entityMap[i];

      final shouldSkip = entity is twt.TweetUrl &&
          (entity.displayUrl.startsWith("pic.twitter.com/"));

      if (!shouldSkip) {
        if (entity == null) {
          buffer.write(text[i]);
          i++;
          continue;
        }

        if (entity is twt.TweetUrl) {
          buffer.write(entity.expandedUrl);
        } else {
          throw UnsupportedError("Cannot handle ${entity.runtimeType}");
        }
      }

      final length = entity.end - entity.start;
      i += length;
    }

    return buffer.toString();
  }
}

extension TweetUrlExtensions on twt.TweetUrl {
  ktk.Embed toKaiteki() {
    return ktk.Embed(
      uri: Uri.parse(expandedUrl),
      title: title,
      description: description,
    );
  }
}

extension MediaExtensions on twt.Media {
  ktk.Attachment toKaiteki() {
    return ktk.Attachment(
      source: this,
      previewUrl: previewImageUrl.nullTransform(Uri.parse),
      url: Uri.parse(url ?? previewImageUrl!),
      type: type.toKaiteki(),
      description: altText,
    );
  }
}

extension MediaTypeExtensions on twt.MediaType {
  ktk.AttachmentType toKaiteki() {
    return const {
      twt.MediaType.animatedGif: ktk.AttachmentType.animated,
      twt.MediaType.photo: ktk.AttachmentType.image,
      twt.MediaType.video: ktk.AttachmentType.video,
    }[this]!;
  }
}
