import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/model.dart";

class AttachmentTrayItem extends StatelessWidget {
  final VoidCallback? onRemove;
  final VoidCallback? onChangeDescription;
  final VoidCallback? onToggleSensitive;

  const AttachmentTrayItem({
    super.key,
    required this.attachment,
    this.onRemove,
    this.onChangeDescription,
    this.onToggleSensitive,
  });

  final AttachmentDraft attachment;

  @override
  Widget build(BuildContext context) {
    const size = 72.0;

    final opacity = attachment.isSensitive ? 0.25 : 1.0;
    final file = attachment.file;
    final widget = switch (AttachmentType.image) {
      AttachmentType.image when file != null => Image(
          image: file.getImageProvider(),
          fit: BoxFit.cover,
          opacity: AlwaysStoppedAnimation(opacity),
        ),
      _ => Center(child: _buildFallbackIcon(AttachmentType.file)),
    };

    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        color: theme.colorScheme.surfaceVariant,
        elevation: 4.0,
        child: PopupMenuButton(
          color: theme.colorScheme.surfaceVariant,
          itemBuilder: buildItemActions,
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              children: [
                Positioned.fill(child: widget),
                if (attachment.isSensitive)
                  Center(
                    child: Icon(
                      Icons.warning_rounded,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<PopupMenuEntry> buildItemActions(BuildContext context) {
    return [
      PopupMenuItem(
        onTap: () => onToggleSensitive?.call(),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(
            attachment.isSensitive
                ? Icons.warning_amber_rounded
                : Icons.warning_rounded,
          ),
          title: Text(
            attachment.isSensitive //
                ? "Mark as safe"
                : "Mark as sensitive",
          ),
        ),
      ),
      PopupMenuItem(
        onTap: () => onChangeDescription?.call(),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.drive_file_rename_outline_rounded),
          title: Text(context.l10n.changeAltText),
        ),
      ),
      PopupMenuItem(
        onTap: () => onRemove?.call(),
        enabled: onRemove != null,
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.close_rounded),
          title: Text(context.l10n.removeAttachmentButtonLabel),
        ),
      ),
    ];
  }

  Widget _buildFallbackIcon(AttachmentType type) {
    return switch (type) {
      AttachmentType.video => const Icon(Icons.video_file_rounded),
      AttachmentType.image => const Icon(Icons.image_rounded),
      AttachmentType.audio => const Icon(Icons.audio_file_rounded),
      AttachmentType.file => const Icon(Icons.insert_drive_file_rounded),
      AttachmentType.animated => const Icon(Icons.gif_box_rounded),
    };
  }
}
