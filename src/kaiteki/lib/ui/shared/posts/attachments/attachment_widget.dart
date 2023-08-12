import "package:flutter/material.dart";
import "package:flutter_blurhash/flutter_blurhash.dart";
import "package:kaiteki/platform_checks.dart";
import "package:kaiteki/theming/kaiteki/text_theme.dart";
import "package:kaiteki/ui/shared/posts/attachments/fallback_attachment_widget.dart";
import "package:kaiteki/ui/shared/posts/attachments/image_attachment_widget.dart";
import "package:kaiteki/ui/shared/posts/attachments/video_attachment_widget.dart";
import "package:kaiteki_core/model.dart";

class AttachmentWidget extends StatelessWidget {
  final Attachment attachment;
  final BoxFit? boxFit;
  final bool showDescriptionBadge;

  /// Whether the attachment is revealed
  final bool? reveal;

  const AttachmentWidget({
    super.key,
    required this.attachment,
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

    Widget attachmentWidget;

    if (attachment.type == AttachmentType.image) {
      // HACK(Craftplacer): missing case when null
      attachmentWidget = ImageAttachmentWidget(
        attachment: attachment,
        boxFit: boxFit,
      );
    } else if (attachment.type == AttachmentType.video && supportsVideoPlayer) {
      attachmentWidget = VideoAttachmentWidget(attachment: attachment);
    } else {
      attachmentWidget = FallbackAttachmentWidget(attachment: attachment);
    }

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

class AltTextBadge extends StatelessWidget {
  const AltTextBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final background = Theme.of(context).colorScheme.inverseSurface;
    final foreground = Theme.of(context).colorScheme.onInverseSurface;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: background,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: DefaultTextStyle(
          style: TextStyle(color: foreground),
          child: Text(
            "ALT",
            style: Theme.of(context).ktkTextTheme?.monospaceTextStyle ??
                DefaultKaitekiTextTheme(context).monospaceTextStyle,
          ),
        ),
      ),
    );
  }
}
