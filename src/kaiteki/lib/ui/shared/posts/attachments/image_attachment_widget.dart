import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/model/attachment.dart';
import 'package:kaiteki/fediverse/model/post/post.dart';
import 'package:kaiteki/ui/shared/attachment_inspection_screen.dart';

class ImageAttachmentWidget extends StatelessWidget {
  final Attachment attachment;
  final int index;
  final Post post;
  final BoxFit? boxFit;

  const ImageAttachmentWidget({
    required this.attachment,
    required this.index,
    required this.post,
    super.key,
    this.boxFit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => enlargeImage(context),
      child: Image.network(
        attachment.previewUrl, // ?? attachment.url
        loadingBuilder: (context, widget, loadingProgress) {
          if (loadingProgress == null) {
            return widget;
          }

          double? progress;

          if (loadingProgress.expectedTotalBytes != null) {
            progress = loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!;
          }

          return Center(
            child: CircularProgressIndicator(value: progress),
          );
        },
        errorBuilder: (_, w, c) {
          return Center(
            child: Icon(
              Icons.hide_image_rounded,
              size: 72,
              color: Theme.of(context).disabledColor,
            ),
          );
        },
        fit: boxFit ?? BoxFit.cover,
        filterQuality: FilterQuality.medium,
        isAntiAlias: true,
      ),
    );
  }

  void enlargeImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AttachmentInspectionScreen(
          attachments: post.attachments!,
          index: index,
        );
      },
    );
  }
}
