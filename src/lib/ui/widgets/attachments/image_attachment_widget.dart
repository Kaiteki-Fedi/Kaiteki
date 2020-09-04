import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/api/model/mastodon/media_attachment.dart';
import 'package:kaiteki/theming/theme_container.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

class ImageAttachmentWidget extends StatelessWidget {
  final MastodonMediaAttachment attachment;

  const ImageAttachmentWidget(this.attachment);

  @override
  Widget build(BuildContext context) {
    var themeContainer = Provider.of<ThemeContainer>(context);
    var border = themeContainer.currentTheme.borderColor;

    var borderRadius = BorderRadius.circular(8);

    return Container(
      decoration: BoxDecoration(
        // TODO (theming): Implement pleroma attachment rounding
        borderRadius: borderRadius,
        border: Border.all(color: border, width: 1)
      ),
      child: GestureDetector(
        onTap: () => enlargeImage(context),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Image.network(
            attachment.previewUrl ?? attachment.url,
            loadingBuilder: (_, w, c) {
              if (c == null ||
                  c.cumulativeBytesLoaded == null ||
                  c.expectedTotalBytes == null)
                return w;

              return Center(
                child: CircularProgressIndicator(value: c.cumulativeBytesLoaded / c.expectedTotalBytes)
              );
            },
            errorBuilder: (_, w, c) {
              return Center(
                child: Icon(Mdi.alert)
              );
            },
            //width: 100,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.medium,
            isAntiAlias: true,
          ),
        ),
      ),
    );
  }

  void enlargeImage(BuildContext context) {
    var background = Colors.black.withOpacity(0.5);

    showDialog(
      context: context,
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: attachment.description == null
            ? null
            : Text(attachment.description ?? ""),
        ),
        body: Center(
          child: ExtendedImage.network(
            attachment.url,
            fit: BoxFit.fill,

            //enableLoadState: false,
            mode: ExtendedImageMode.gesture,
            initGestureConfigHandler: (state) {
              return GestureConfig(
                minScale: 1,
                animationMinScale: 0.7,
                maxScale: 5.0,
                animationMaxScale: 5.0,
                speed: 1.0,
                inertialSpeed: 100.0,
                initialScale: 1.0,
                inPageView: false,
                initialAlignment: InitialAlignment.center,
              );
            },
          ),
        )

      )
    );
  }
}
