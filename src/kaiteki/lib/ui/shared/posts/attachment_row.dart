import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/model/attachment.dart";
import "package:kaiteki/fediverse/model/post/post.dart";
import "package:kaiteki/preferences/theme_preferences.dart";
import "package:kaiteki/ui/shared/bottom_sheets/attachment.dart";
import "package:kaiteki/ui/shared/posts/attachments/attachment_widget.dart";

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
          child: SizedBox(
            height: 320,
            child: AspectRatio(
              aspectRatio: 1.5,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        for (var attachment in widget.post.attachments!.take(4))
                          Flexible(
                            child: InkWell(
                              onTap: () {},
                              onLongPress: () =>
                                  _showAttachmentActions(attachment),
                              child: AttachmentWidget(
                                attachment: attachment,
                                reveal: revealed,
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
                ],
              ),
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
