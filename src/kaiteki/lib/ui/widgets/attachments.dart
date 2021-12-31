import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:kaiteki/fediverse/model/attachment.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/ui/widgets/attachments/fallback_attachment_widget.dart';
import 'package:kaiteki/ui/widgets/attachments/image_attachment_widget.dart';
import 'package:kaiteki/ui/widgets/attachments/video_attachment_widget.dart';

Widget getAttachmentWidget(Post post, Attachment attachment, int index) {
  final supportsVideoPlayer = kIsWeb || Platform.isIOS || Platform.isAndroid;

  if (attachment.type == AttachmentType.image) {
    return ImageAttachmentWidget(
      attachment: attachment,
      index: index,
      post: post,
    );
  } else if (attachment.type == AttachmentType.video && supportsVideoPlayer) {
    return VideoAttachmentWidget(attachment: attachment);
  } else {
    return FallbackAttachmentWidget(attachment: attachment);
  }
}
