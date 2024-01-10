import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:fpdart/fpdart.dart";
import "package:kaiteki/ui/shared/posts/compose/attachment_tray_item.dart";
import "package:kaiteki_core/model.dart";

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
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: attachments
            .mapIndexed<Widget>((i, e) {
              return AttachmentTrayItem(
                attachment: attachments[i],
                onRemove: () => onRemoveAttachment?.call(i),
                onChangeDescription: () => onChangeDescription?.call(i),
                onToggleSensitive: () => onToggleSensitive?.call(i),
              );
            })
            .intersperse(const SizedBox(width: 8.0))
            .toList(),
      ),
    );
  }
}
