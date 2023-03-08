import "package:flutter/material.dart";
import "package:kaiteki/fediverse/model/post/draft.dart";
import "package:kaiteki/ui/shared/dialogs/responsive_dialog.dart";

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
      builder: (context, fullscreen) {
        final attachment = widget.attachment;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: const Text("Change alt text"),
              forceMaterialTransparency: true,
              actions: [
                if (fullscreen)
                  TextButton(
                    onPressed: () => _onApply(context),
                    child: const Text("Apply"),
                  ),
                const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 16),
            if (attachment != null)
              AspectRatio(
                aspectRatio: 16.0 / 9.0,
                child: Image.file(attachment.file!.toDartFile()!),
              ),
            Flexible(
              flex: fullscreen ? 1 : 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  expands: fullscreen,
                  minLines: fullscreen ? null : 6,
                  maxLines: fullscreen ? null : 8,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Describe the attachment",
                  ),
                  textAlignVertical: TextAlignVertical.top,
                ),
              ),
            ),
            if (!fullscreen) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => _onCancel(context),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () => _onApply(context),
                    child: const Text("Apply"),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }

  void _onCancel(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _onApply(BuildContext context) {
    Navigator.of(context).pop(_controller.text);
  }
}
