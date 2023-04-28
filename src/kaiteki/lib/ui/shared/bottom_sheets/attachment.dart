import "package:flutter/material.dart";
import "package:kaiteki/fediverse/model/attachment.dart";
import "package:kaiteki/ui/share_sheet/share.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:url_launcher/url_launcher.dart";

class AttachmentBottomSheet extends StatelessWidget {
  final Attachment attachment;

  const AttachmentBottomSheet(this.attachment, {super.key});

  @override
  Widget build(BuildContext context) {
    final description = attachment.description;
    final hasDescription = description != null && description.isNotEmpty;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        dragHandleInset,
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: hasDescription
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SelectableText(description),
                    // const SizedBox(height: 8),
                    // Wrap(
                    //   children: [
                    //     ActionChip(
                    //       avatar: Icon(Icons.translate_rounded),
                    //       label: Text("Translate"),
                    //       onPressed: () {},
                    //     ),
                    //   ],
                    // ),
                  ],
                )
              : Text(
                  "No description provided",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
        ),
        const Divider(),
        const SizedBox(height: 8),
        const ListTile(
          leading: Icon(Icons.download_rounded),
          title: Text("Download"),
        ),
        ListTile(
          leading: Icon(Icons.adaptive.share_rounded),
          title: const Text("Share"),
          onTap: () async {
            Navigator.of(context).pop();
            await share(context, attachment.url);
          },
        ),
        ListTile(
          leading: const Icon(Icons.open_in_browser_rounded),
          title: const Text("Open in browser"),
          onTap: () async {
            Navigator.of(context).pop();
            await launchUrl(
              attachment.url,
              mode: LaunchMode.externalApplication,
            );
          },
        ),
      ],
    );
  }
}
