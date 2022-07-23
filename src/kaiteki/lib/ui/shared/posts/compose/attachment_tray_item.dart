import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/model/attachment.dart';

class AttachmentTrayItem extends StatelessWidget {
  final VoidCallback? onRemove;

  const AttachmentTrayItem({
    super.key,
    required this.attachment,
    this.onRemove,
  });

  final Future<Attachment> attachment;

  @override
  Widget build(BuildContext context) {
    const size = 72.0;

    return FutureBuilder(
      future: attachment,
      // ignore: avoid_types_on_closure_parameters
      builder: (context, AsyncSnapshot<Attachment> snapshot) {
        final Widget widget;

        if (snapshot.hasError) {
          widget = const Center(child: Icon(Icons.error));
        } else if (!snapshot.hasData) {
          widget = const Center(child: CircularProgressIndicator());
        } else {
          final attachment = snapshot.data!;
          switch (attachment.type) {
            case AttachmentType.image:
              widget = Image.network(
                snapshot.data!.url,
                fit: BoxFit.cover,
              );
              break;
            default:
              widget = Center(
                child: _buildFallbackIcon(attachment.type),
              );
              break;
          }
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            borderRadius: BorderRadius.circular(8.0),
            elevation: 4.0,
            child: Stack(
              children: [
                SizedBox(
                  width: size,
                  height: size,
                  child: ColoredBox(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: widget,
                  ),
                ),
                Positioned(
                  right: 0,
                  child: PopupMenuButton(
                    iconSize: 20,
                    splashRadius: 12,
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    onSelected: (action) {
                      switch (action) {
                        case AttachmentTryItemAction.remove:
                          onRemove?.call();
                          break;
                      }
                    },
                    itemBuilder: buildItemActions,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<PopupMenuEntry<AttachmentTryItemAction>> buildItemActions(context) {
    return [
      PopupMenuItem(
        value: AttachmentTryItemAction.remove,
        enabled: onRemove != null,
        child: const ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.close_rounded),
          title: Text("Remove attachment"),
        ),
      ),
      const PopupMenuItem(
        value: AttachmentTryItemAction.addAltText,
        enabled: false,
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(
            Icons.drive_file_rename_outline_rounded,
          ),
          title: Text("Add alternate text"),
        ),
      ),
    ];
  }

  Widget _buildFallbackIcon(AttachmentType type) {
    switch (type) {
      case AttachmentType.video:
        return const Icon(Icons.video_file_rounded);
      case AttachmentType.audio:
        return const Icon(Icons.audio_file_rounded);
      case AttachmentType.file:
      default:
        return const Icon(Icons.insert_drive_file_rounded);
    }
  }
}

enum AttachmentTryItemAction { remove, addAltText }
