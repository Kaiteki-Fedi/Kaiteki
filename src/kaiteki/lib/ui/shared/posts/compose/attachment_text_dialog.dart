import "package:async/async.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:kaiteki/constants.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/link_constants.dart";
import "package:kaiteki/ui/media/media.dart";
import "package:kaiteki/ui/media/media_preview.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki_core/kaiteki_core.dart";
import "package:mime/mime.dart";
import "package:url_launcher/url_launcher.dart";

class AttachmentTextDialog extends StatefulWidget {
  final AttachmentDraft? attachment;

  const AttachmentTextDialog({super.key, required this.attachment});

  @override
  State<AttachmentTextDialog> createState() => _AttachmentTextDialogState();
}

class _AttachmentTextDialogState extends State<AttachmentTextDialog> {
  late TextEditingController _controller;
  late Future<LocalMedia> _mediaFuture;

  @override
  void initState() {
    super.initState();

    final attachment = widget.attachment!;

    _controller = TextEditingController(text: attachment.description);

    final mimeType = attachment.file!.mimeType;
    if (mimeType == null) {
      Future<LocalMedia> determineMime() async {
        final file = attachment.file!;

        final fileHeader = await collectBytes(file.openRead(0, 32));
        final mimeType = lookupMimeType(file.name, headerBytes: fileHeader);

        return LocalMedia(
          attachment.file!,
          type: mimeType.andThen(MediaType.determineFromMimeType) ??
              MediaType.file,
        );
      }

      _mediaFuture = determineMime();
    } else {
      final mediaType = MediaType.determineFromMimeType(mimeType);
      _mediaFuture = Future.value(
        LocalMedia(
          attachment.file!,
          type: mediaType,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCompact = WindowWidthSizeClass.fromContext(context) <=
        WindowWidthSizeClass.compact;

    final closeButton = IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(Icons.close_rounded),
    );

    final applyButton = TextButton(
      onPressed: () => _onApply(context),
      child: Text(context.l10n.applyButtonLabel),
    );

    final helpButton = IconButton(
      onPressed: () async => launchUrl(altTextGuide),
      icon: const Icon(Icons.help_rounded),
      tooltip: "Help",
    );

    final preview = Card.outlined(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: _mediaFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Failure loading media");
          } else if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return MediaPreview(snapshot.data as Media);
          }
        },
      ),
    );

    const inputDecoration = InputDecoration(
      border: OutlineInputBorder(),
      hintText: "Describe the attachment",
      isDense: true,
    );

    if (isCompact) {
      return Dialog.fullscreen(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              leading: closeButton,
              title: Text(context.l10n.changeAltText),
              forceMaterialTransparency: true,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              actions: [
                helpButton,
                kAppBarActionsSpacer,
                applyButton,
                kAppBarActionsSpacer,
              ],
            ),
            Expanded(child: preview),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                autofocus: true,
                minLines: 1,
                maxLines: null,
                onSubmitted: (_) => _onApply(context),
                decoration: inputDecoration,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
          ],
        ),
      );
    }

    return Dialog(
      child: ConstrainedBox(
        constraints: kDialogConstraints,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              title: Text(context.l10n.changeAltText),
              forceMaterialTransparency: true,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
              actions: [
                helpButton,
                kAppBarActionsSpacer,
                closeButton,
                kAppBarActionsSpacer,
              ],
            ),
            Flexible(
              child: preview,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                autofocus: true,
                maxLines: null,
                decoration: inputDecoration,
                onSubmitted: (_) => _onApply(context),
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
            DialogButtonBar(
              children: [applyButton],
            ),
          ],
        ),
      ),
    );
  }

  void _onApply(BuildContext context) {
    Navigator.of(context).pop(_controller.text);
  }
}
