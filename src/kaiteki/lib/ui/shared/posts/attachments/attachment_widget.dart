import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/model/attachment.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/ui/shared/posts/attachments/fallback_attachment_widget.dart';
import 'package:kaiteki/ui/shared/posts/attachments/image_attachment_widget.dart';
import 'package:kaiteki/ui/shared/posts/attachments/video_attachment_widget.dart';

class AttachmentWidget extends StatefulWidget {
  final Attachment attachment;
  final Post? parentPost;
  final int? attachmentIndex;

  const AttachmentWidget({
    super.key,
    required this.attachment,
    this.parentPost,
    this.attachmentIndex,
  });

  @override
  State<AttachmentWidget> createState() => _AttachmentWidgetState();
}

class _AttachmentWidgetState extends State<AttachmentWidget> {
  bool revealed = false;

  @override
  Widget build(BuildContext context) {
    if (widget.attachment.isSensitive && !revealed) {
      return Center(
        child: OutlinedButton(
          onPressed: () => setState(() => revealed = true),
          child: const Text("Reveal sensitive content"),
        ),
      );
    }

    final supportsVideoPlayer = kIsWeb || Platform.isIOS || Platform.isAndroid;

    if (widget.attachment.type == AttachmentType.image) {
      // HACK: missing case when null
      return ImageAttachmentWidget(
        attachment: widget.attachment,
        index: widget.attachmentIndex!,
        post: widget.parentPost!,
      );
    } else if (widget.attachment.type == AttachmentType.video &&
        supportsVideoPlayer) {
      return VideoAttachmentWidget(attachment: widget.attachment);
    } else {
      return FallbackAttachmentWidget(attachment: widget.attachment);
    }
  }
}
