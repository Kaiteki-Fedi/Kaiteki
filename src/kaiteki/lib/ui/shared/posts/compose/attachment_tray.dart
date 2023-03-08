import "package:flutter/material.dart";
import "package:kaiteki/fediverse/model/post/draft.dart";
import "package:kaiteki/ui/shared/posts/compose/attachment_tray_item.dart";

class AttachmentTray extends StatelessWidget {
  final Function(int index)? onRemoveAttachment;
  final Function(int index)? onChangeDescription;
  final Function(int index)? onToggleSensitive;

  const AttachmentTray({
    super.key,
    required this.attachments,
    this.onRemoveAttachment,
    this.onChangeDescription,
    this.onToggleSensitive,
  });

  final List<AttachmentDraft> attachments;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < attachments.length; i++)
            AttachmentTrayItem(
              attachment: attachments[i],
              onRemove: () => onRemoveAttachment?.call(i),
              onChangeDescription: () => onChangeDescription?.call(i),
              onToggleSensitive: () => onToggleSensitive?.call(i),
            ),
        ],
      ),
    );
  }
}
