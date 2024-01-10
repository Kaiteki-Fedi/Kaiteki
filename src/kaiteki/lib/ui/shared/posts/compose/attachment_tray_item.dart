import "package:cross_file_image/cross_file_image.dart";
import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki_core/model.dart";

class AttachmentTrayItem extends StatefulWidget {
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
  State<AttachmentTrayItem> createState() => _AttachmentTrayItemState();
}

class _AttachmentTrayItemState extends State<AttachmentTrayItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    const size = 72.0;

    final isSensitive = this.widget.attachment.isSensitive;
    final opacity = isSensitive || isHovered ? 0.25 : 1.0;
    final file = this.widget.attachment.file;

    final widget = switch (AttachmentType.image) {
      AttachmentType.image when file != null => Image(
          image: XFileImage(file),
          fit: BoxFit.cover,
          opacity: AlwaysStoppedAnimation(opacity),
          errorBuilder: (context, _, __) => Icon(
            Icons.broken_image_rounded,
            color: IconTheme.of(context).color?.withOpacity(opacity),
          ),
        ),
      _ => Center(child: _buildFallbackIcon(AttachmentType.file)),
    };

    final theme = Theme.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
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
          tooltip: "",
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              children: [
                Positioned.fill(child: widget),
                if (isHovered)
                  Center(
                    child: Icon(
                      Icons.adaptive.more_rounded,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  )
                else if (isSensitive)
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
        onTap: () => widget.onToggleSensitive?.call(),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(
            widget.attachment.isSensitive
                ? Icons.warning_amber_rounded
                : Icons.warning_rounded,
          ),
          title: Text(
            widget.attachment.isSensitive //
                ? "Mark as safe"
                : "Mark as sensitive",
          ),
        ),
      ),
      PopupMenuItem(
        onTap: () => widget.onChangeDescription?.call(),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.drive_file_rename_outline_rounded),
          title: Text(context.l10n.changeAltText),
        ),
      ),
      PopupMenuItem(
        onTap: () => widget.onRemove?.call(),
        enabled: widget.onRemove != null,
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
