import "package:flutter/material.dart";
import "package:flutter_blurhash/flutter_blurhash.dart";
import "package:kaiteki_core/model.dart";

class ImageAttachment extends StatelessWidget {
  final Attachment attachment;
  final BoxFit? boxFit;

  const ImageAttachment({
    super.key,
    required this.attachment,
    this.boxFit,
  });

  @override
  Widget build(BuildContext context) {
    final url = attachment.previewUrl ?? attachment.url;
    final label = attachment.description ?? attachment.fileName;
    // final locale = attachment.descriptionLanguage.andThen(Locale.new);
    return Semantics(
      image: true,
      label: label,
      child: Image.network(
        url.toString(),
        loadingBuilder: (context, widget, loadingProgress) {
          if (loadingProgress == null) return widget;

          double? progress;

          final expectedTotalBytes = loadingProgress.expectedTotalBytes;
          if (expectedTotalBytes != null) {
            progress =
                loadingProgress.cumulativeBytesLoaded / expectedTotalBytes;
          }

          final blurHash = attachment.blurHash;
          return Stack(
            children: [
              if (blurHash != null && blurHash.isNotEmpty)
                BlurHash(hash: attachment.blurHash!),
              Center(
                child: CircularProgressIndicator.adaptive(
                  value: progress,
                  strokeCap: StrokeCap.round,
                ),
              ),
            ],
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
}
