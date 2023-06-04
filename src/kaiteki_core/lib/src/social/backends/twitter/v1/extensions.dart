import 'package:kaiteki_core/social.dart';
import 'package:kaiteki_core/utils.dart';

import 'model/entities/entities.dart' as twitter;
import 'model/entities/media.dart' as twitter;
import 'model/entities/url.dart' as twitter;
import 'model/tweet.dart' as twitter;
import 'model/user.dart' as twitter;

String _removeEntities(
  String text,
  twitter.Entities? entities, {
  bool removeMediaLinks = true,
  bool expandLinks = true,
}) {
  if (entities == null) return text;

  var replacedText = text;

  final totalEntities = entities.aggregated
    ..sort((a, b) => a.indices[0].compareTo(b.indices[0]));

  for (final entity in totalEntities) {
    if (entity is twitter.Media && removeMediaLinks) {
      replacedText = text.replaceRange(
        entity.indices[0],
        entity.indices[1],
        '',
      );
    } else if (entity is twitter.Url && expandLinks) {
      replacedText = text.replaceRange(
        entity.indices[0],
        entity.indices[1],
        entity.expandedUrl,
      );
    }
  }

  return replacedText;
}

extension KaitekiMediaExtensions on twitter.Media {
  Attachment toKaiteki() {
    return Attachment(
      source: this,
      url: Uri.parse(mediaUrlHttps),
      previewUrl: Uri.parse(mediaUrlHttps),
      type: switch (type) {
        'photo' => AttachmentType.image,
        'video' => AttachmentType.video,
        'animated_gif' => AttachmentType.animated,
        _ => AttachmentType.file,
      },
    );
  }
}

extension KaitekiTweetExtensions on twitter.Tweet {
  Post toKaiteki() {
    return Post(
      author: user.toKaiteki(),
      id: idStr,
      postedAt: createdAt,
      source: this,
      content: _removeEntities(text, entities),
      metrics: PostMetrics(
        favoriteCount: favoriteCount,
        repeatCount: retweetCount,
      ),
      attachments: entities.media?.map((e) => e.toKaiteki()).toList(),
      replyToUser: inReplyToUserIdStr.nullTransform(ResolvableUser.fromId),
      replyTo: inReplyToStatusIdStr.nullTransform(ResolvablePost.fromId),
      mentionedUsers: entities.userMentions?.map((e) {
        return UserReference(e.idStr);
      }).toList(),
      quotedPost: quotedStatus.nullTransform((e) => e.toKaiteki()),
      repeatOf: retweetedStatus.nullTransform((e) => e.toKaiteki()),
    );
  }
}

extension KaitekiUserExtensions on twitter.User {
  User toKaiteki() {
    return User(
      displayName: name,
      host: 'twitter.com',
      id: idStr,
      source: this,
      username: screenName,
      description: description,
      avatarUrl: profileImageUrlHttps.nullTransform(Uri.parse),
      bannerUrl: profileBannerUrl.nullTransform(Uri.parse),
      metrics: UserMetrics(postCount: statusesCount),
      details: UserDetails(
        location: location,
        website: url.nullTransform((e) => _removeEntities(e, entities.url)),
      ),
      joinDate: createdAt,
    );
  }
}
