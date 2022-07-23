import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/ui/shared/posts/attachments/attachment_widget.dart';

class AttachmentRow extends StatelessWidget {
  final Post post;

  const AttachmentRow({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final border = Theme.of(context).dividerColor;
    final borderRadius = BorderRadius.circular(8);
    var attachmentIndex = 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        for (var attachment in post.attachments!.take(4))
          Flexible(
            child: SizedBox(
              height: 280,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  border: Border.all(color: border),
                ),
                child: AttachmentWidget(
                  parentPost: post,
                  attachment: attachment,
                  attachmentIndex: attachmentIndex++,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
