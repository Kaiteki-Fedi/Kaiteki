import "package:flutter/material.dart";
import "package:flutter_blurhash/flutter_blurhash.dart";
import "package:kaiteki/platform_checks.dart";
import "package:kaiteki_core/model.dart";
import "package:kaiteki_core/social.dart";

import "alt_text_badge.dart";
import "fallback_attachment_widget.dart";
import "image_attachment.dart";
import "video_attachment_widget.dart";

class AttachmentWidget extends StatelessWidget {
  final Attachment attachment;
  final BoxFit? boxFit;
  final bool showDescriptionBadge;

  /// Whether the attachment is revealed
  final bool? reveal;

  final VoidCallback? onTap;

  const AttachmentWidget({
    super.key,
    required this.attachment,
    this.onTap,
    this.boxFit,
    this.reveal,
    this.showDescriptionBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    final revealed = reveal ?? !(attachment.isSensitive ?? false);

    final blurHash = attachment.blurHash;
    final isBlurHashAvailable = blurHash != null && blurHash.isNotEmpty;
    if (!revealed) {
      if (isBlurHashAvailable) return BlurHash(hash: blurHash);
      return const SizedBox.expand();
    }

    final attachmentWidget = switch (attachment.type) {
      AttachmentType.video when supportsVideoPlayer =>
        VideoAttachment(attachment: attachment),
      AttachmentType.image => InkWell(
          onTap: onTap,
          child: ImageAttachment(
            attachment: attachment,
            boxFit: boxFit,
          ),
        ),
      _ => FallbackAttachmentWidget(attachment: attachment),
    };

    return Stack(
      fit: StackFit.expand,
      children: [
        attachmentWidget,
        if (showDescriptionBadge && attachment.description?.isNotEmpty == true)
          const Positioned(
            top: 8,
            right: 8,
            child: AltTextBadge(),
          ),
      ],
    );
  }
}
