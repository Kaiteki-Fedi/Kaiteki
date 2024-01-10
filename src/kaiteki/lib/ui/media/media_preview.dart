import "package:cross_file_image/cross_file_image.dart";
import "package:flutter/material.dart";
import "package:kaiteki/ui/media/video_player.dart";

import "media.dart";

class MediaPreview extends StatelessWidget {
  final Media media;
  final VoidCallback? onTapImage;

  const MediaPreview(this.media, {this.onTapImage, super.key});

  @override
  Widget build(BuildContext context) {
    final media = this.media;
    switch (media.type) {
      case MediaType.image:
        final imageProvider = switch (media) {
          RemoteMedia() => NetworkImage(media.url.toString()),
          LocalMedia() => XFileImage(media.file),
        };
        return InteractiveViewer(
          child: GestureDetector(
            excludeFromSemantics: true,
            onTap: onTapImage,
            child: Center(
              child: Semantics(
                label: media.description,
                image: true,
                focusable: true,
                child: Image(
                  // Dart is acting funny
                  image: imageProvider as ImageProvider,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      case MediaType.video:
        return VideoPlayer.fromMedia(media);
      default:
        return Text("Files of type ${media.type.name} are not supported.");
    }
  }
}
