import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/theme_preferences.dart";
import "package:kaiteki/ui/media_inspection/screen.dart";
import "package:kaiteki/ui/shared/attachment_flex.dart";
import "package:kaiteki/ui/shared/bottom_sheets/attachment.dart";
import "package:kaiteki/ui/shared/posts/attachments/attachment_widget.dart";
import "package:kaiteki_core/social.dart";

class AttachmentRow extends ConsumerStatefulWidget {
  final Post post;

  const AttachmentRow({
    super.key,
    required this.post,
  });

  @override
  ConsumerState<AttachmentRow> createState() => _AttachmentRowState();
}

class _AttachmentRowState extends ConsumerState<AttachmentRow> {
  bool revealed = false;

  @override
  void initState() {
    super.initState();
    revealed = !widget.post.attachments!.any((a) => a.isSensitive ?? false);
  }

  @override
  Widget build(BuildContext context) {
    final border = Theme.of(context).dividerColor;
    final borderRadius = BorderRadius.circular(8);

    final attachments = widget.post.attachments!;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: Border.all(color: border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Material(
          borderRadius: BorderRadius.circular(8.0),
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 320,
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: AttachmentFlex(
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    children: [
                      for (final attachment in attachments.take(4))
                        Semantics(
                          image: true,
                          button: false,
                          child: InkWell(
                            onLongPress: () =>
                                _showAttachmentActions(attachment),
                            child: AttachmentWidget(
                              attachment: attachment,
                              reveal: revealed,
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (_) {
                                    return MediaInspectionScreen.fromPost(
                                      widget.post,
                                      initialIndex:
                                          attachments.indexOf(attachment),
                                    );
                                  },
                                );
                              },
                              boxFit: ref.watch(cropAttachments).value
                                  ? BoxFit.cover
                                  : BoxFit.contain,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (!revealed)
                  Center(
                    child: FilledButton.tonal(
                      onPressed: reveal,
                      child: const Text("Show sensitive content"),
                    ),
                  ),
                if (attachments.length > 4)
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Text("+${attachments.length - 4}"),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showAttachmentActions(Attachment attachment) async {
    return showModalBottomSheet(
      context: context,
      builder: (context) => AttachmentBottomSheet(attachment),
    );
  }

  void reveal() => setState(() => revealed = true);

  void hide() => setState(() => revealed = false);
}
