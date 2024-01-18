import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:fpdart/fpdart.dart";
import "package:kaiteki/ui/shared/posts/compose/attachment_tray_item.dart";
import "package:kaiteki_core/model.dart";

class AttachmentTray extends StatelessWidget {
  final Function(int index)? onRemoveAttachment;
  final Function(int index)? onChangeDescription;
  final Function(int index)? onToggleSensitive;
  final VoidCallback? onChangePoll;

  const AttachmentTray({
    super.key,
    required this.attachments,
    this.onRemoveAttachment,
    this.onChangeDescription,
    this.onToggleSensitive,
    this.onChangePoll,
  });

  final List<AttachmentDraft> attachments;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          if (onChangePoll != null) _PollButton(onTap: onChangePoll),
          ...attachments.mapIndexed<Widget>((i, e) {
            return AttachmentTrayItem(
              attachment: attachments[i],
              onRemove: () => onRemoveAttachment?.call(i),
              onChangeDescription: () => onChangeDescription?.call(i),
              onToggleSensitive: () => onToggleSensitive?.call(i),
            );
          }),
        ].intersperse(const SizedBox(width: 8.0)).toList(),
      ),
    );
  }
}

class _PollButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _PollButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      color: theme.colorScheme.surfaceVariant,
      elevation: 4.0,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 72,
          height: 72,
          child: Center(
            child: Icon(
              Icons.bar_chart_rounded,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
