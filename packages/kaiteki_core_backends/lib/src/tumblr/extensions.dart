import 'package:collection/collection.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:kaiteki_core/social.dart';
import 'package:kaiteki_core/utils.dart';

import 'entities/blog.dart' as tumblr;
import 'entities/post.dart' as tumblr;
import 'entities/user_info.dart' as tumblr;

extension TumblrUserInfoKaitekiExtension on tumblr.UserInfo {
  User toKaiteki() {
    return User(
      username: name,
      id: name,
      displayName: null,
      metrics: UserMetrics(
        followingCount: following,
      ),
      host: 'tumblr.com',
    );
  }
}

extension TumblrPostKaitekiExtension on tumblr.Post {
  Post toKaiteki() {
    List<Attachment> getAttachments(Element element) {
      if (element.localName != 'img') {
        return element.children.expand(getAttachments).toList();
      }

      return [
        Attachment(
          url: Uri.parse(element.attributes['src']!),
          type: AttachmentType.image,
          previewUrl: null,
        ),
      ];
    }

    final fragment = body.andThen(parseFragment);
    return Post(
      author: blog.toKaiteki(),
      id: id,
      postedAt: DateTime.now(),
      content: body,
      subject: title,
      attachments: fragment?.children.expand(getAttachments).toList(),
    );
  }
}

extension TumblrBlogKaitekiExtension on tumblr.Blog {
  User toKaiteki() {
    return User(
      username: name,
      id: name,
      displayName: title,
      host: 'tumblr.com',
      avatarUrl: avatar?.lastOrNull?.url,
    );
  }
}
