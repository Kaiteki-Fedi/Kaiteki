import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/model/attachment.dart';
import 'package:kaiteki/ui/shared/posts/compose/attachment_tray_item.dart';

class AttachmentTray extends StatelessWidget {
  final Function(int index)? onRemoveAttachment;

  const AttachmentTray({
    Key? key,
    required this.attachments,
    this.onRemoveAttachment,
  }) : super(key: key);

  final List<Future<Attachment>> attachments;

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
            ),
        ],
      ),
    );
  }
}
