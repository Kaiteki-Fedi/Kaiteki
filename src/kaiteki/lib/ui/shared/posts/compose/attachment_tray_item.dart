import "dart:io";
import "dart:typed_data";

import "package:flutter/material.dart";
import "package:kaiteki/fediverse/model/attachment.dart";
import "package:kaiteki/fediverse/model/post/draft.dart";

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

    Widget widget = Center(
      child: _buildFallbackIcon(AttachmentType.file),
    );

    final opacity = attachment.isSensitive ? 0.25 : 1.0;

    switch (AttachmentType.image) {
      case AttachmentType.image:
        final filePath = attachment.file?.path;
        if (filePath != null) {
          widget = Image.file(
            File(filePath),
            fit: BoxFit.cover,
            opacity: AlwaysStoppedAnimation(opacity),
          );
          break;
        }

        final fileBytes = attachment.file?.bytes;
        if (fileBytes != null) {
          widget = Image.memory(
            Uint8List.fromList(fileBytes),
            fit: BoxFit.cover,
            opacity: AlwaysStoppedAnimation(opacity),
          );
          break;
        }
      default:
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(8.0),
        color: Theme.of(context).colorScheme.surfaceVariant,
        elevation: 4.0,
        child: PopupMenuButton(
          tooltip: "",
          color: Theme.of(context).colorScheme.surfaceVariant,
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
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  )
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
        child: const ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(
            Icons.drive_file_rename_outline_rounded,
          ),
          title: Text("Change description"),
        ),
      ),
      PopupMenuItem(
        onTap: () => onRemove?.call(),
        enabled: onRemove != null,
        child: const ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.close_rounded),
          title: Text("Remove attachment"),
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
