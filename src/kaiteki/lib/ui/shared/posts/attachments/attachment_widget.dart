import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:kaiteki/fediverse/model/attachment.dart';
import 'package:kaiteki/fediverse/model/post/post.dart';
import 'package:kaiteki/platform_checks.dart';
import 'package:kaiteki/ui/shared/posts/attachments/fallback_attachment_widget.dart';
import 'package:kaiteki/ui/shared/posts/attachments/image_attachment_widget.dart';
import 'package:kaiteki/ui/shared/posts/attachments/video_attachment_widget.dart';

class AttachmentWidget extends StatefulWidget {
  final Attachment attachment;
  final Post? parentPost;
  final int? attachmentIndex;
  final BoxFit? boxFit;

  const AttachmentWidget({
    super.key,
    required this.attachment,
    this.parentPost,
    this.boxFit,
    this.attachmentIndex,
  });

  @override
  State<AttachmentWidget> createState() => _AttachmentWidgetState();
}

class _AttachmentWidgetState extends State<AttachmentWidget> {
  bool revealed = false;

  @override
  Widget build(BuildContext context) {
    final blurHash = widget.attachment.blurHash;
    if (widget.attachment.isSensitive && !revealed) {
      return Stack(
        children: [
          if (blurHash != null && blurHash.isNotEmpty)
            BlurHash(hash: widget.attachment.blurHash!),
          Center(
            child: FilledButton.tonal(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.background,
              ),
              onPressed: reveal,
              child: const Text("Show sensitive content"),
            ),
          ),
        ],
      );
    }

    Widget attachmentWidget;

    if (widget.attachment.type == AttachmentType.image) {
      // HACK(Craftplacer): missing case when null
      attachmentWidget = ImageAttachmentWidget(
        attachment: widget.attachment,
        index: widget.attachmentIndex,
        post: widget.parentPost,
        boxFit: widget.boxFit,
      );
    } else if (widget.attachment.type == AttachmentType.video &&
        supportsVideoPlayer) {
      attachmentWidget = VideoAttachmentWidget(attachment: widget.attachment);
    } else {
      attachmentWidget =
          FallbackAttachmentWidget(attachment: widget.attachment);
    }

    return Stack(
      children: [
        Positioned.fill(child: attachmentWidget),
        if (widget.attachment.isSensitive)
          Positioned(
            top: 8,
            right: 8,
            child: Material(
              clipBehavior: Clip.antiAlias,
              shape: const StadiumBorder(),
              color: Theme.of(context)
                  .colorScheme
                  .secondaryContainer
                  .withOpacity(.85),
              child: IconButton(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                icon: const Icon(Icons.visibility_off_rounded),
                onPressed: unreveal,
                splashRadius: 24,
                tooltip: "Hide sensitive content",
              ),
            ),
          ),
      ],
    );
  }

  void reveal() => setState(() => revealed = true);
  void unreveal() => setState(() => revealed = false);
}
