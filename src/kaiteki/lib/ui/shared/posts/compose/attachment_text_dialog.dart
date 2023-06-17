import "package:flutter/material.dart";
import "package:kaiteki/ui/shared/dialogs/responsive_dialog.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/kaiteki_core.dart";
import "package:kaiteki_core/model.dart";

class AttachmentTextDialog extends StatefulWidget {
  final AttachmentDraft? attachment;

  const AttachmentTextDialog({super.key, required this.attachment});

  @override
  State<AttachmentTextDialog> createState() => _AttachmentTextDialogState();
}

class _AttachmentTextDialogState extends State<AttachmentTextDialog> {
  // text controller
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveDialog(
      builder: (context, axis) {
        final fullscreen = axis != null;
        final attachment = widget.attachment;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: const Text("Change alt text"),
              forceMaterialTransparency: true,
              actions: [
                TextButton(
                  onPressed: () => _onApply(context),
                  child: const Text("Apply"),
                ),
                const SizedBox(width: 8),
              ],
            ),
            Flexible(
              flex: fullscreen ? 1 : 0,
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (attachment != null)
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image(
                          image: attachment.file!.getImageProvider(),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _controller,
                        autofocus: true,
                        expands: fullscreen,
                        minLines: fullscreen ? null : 1,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Describe the attachment",
                        ),
                        textAlignVertical: TextAlignVertical.top,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onApply(BuildContext context) {
    Navigator.of(context).pop(_controller.text);
  }
}
