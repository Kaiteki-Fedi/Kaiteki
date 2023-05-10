import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/ui/share_sheet/share.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:url_launcher/url_launcher.dart";

class ShareSheet extends StatelessWidget {
  final Object content;

  const ShareSheet(this.content, {super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      builder: (context) {
        final text = getShareText(content);
        final url = getShareUrl(content);
        const margin = EdgeInsets.symmetric(horizontal: 16.0);
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            dragHandleInset,
            Padding(
              padding: margin,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Share",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton.filledTonal(
                    onPressed: () async {
                      final data = ClipboardData(text: text);
                      await Clipboard.setData(data).then((_) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Copied to clipboard"),
                          ),
                        );
                      });
                    },
                    icon: const Icon(Icons.copy_rounded),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    onPressed: url.nullTransform(
                      (url) {
                        return () => launchUrl(url).then(
                              (_) => Navigator.of(context).pop(),
                            );
                      },
                    ),
                    icon: const Icon(Icons.open_in_new_rounded),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              padding: margin,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  FilterChip(
                    label: const Text("Content"),
                    onSelected: (v) {},
                  ),
                  FilterChip(
                    label: const Text("Link"),
                    onSelected: (v) {},
                  ),
                  FilterChip(
                    label: Text("Link on ${url?.host}"),
                    onSelected: (v) {},
                    selected: true,
                  ),
                ].joinWithValue(const SizedBox(width: 8)),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              margin: margin,
              elevation: 2.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 16.0,
                ),
                child: Row(
                  children: [
                    buildPreviewIcon(context),
                    const SizedBox(width: 8),
                    Expanded(child: buildPreviewBody(context)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(indent: 16, endIndent: 16),
            const SizedBox(height: 16),
            Consumer(
              builder: (context, ref, child) {
                return ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text("Compose"),
                  onTap: () {
                    Navigator.of(context).pop();
                    context.pushNamed(
                      "compose",
                      pathParameters: ref.accountRouterParams,
                      queryParameters: {"body": text},
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        );
      },
      onClosing: () {},
    );
  }

  Widget buildPreviewBody(BuildContext context) {
    final text = getShareText(content);
    return Text(
      text,
      maxLines: 2,
    );
  }

  Widget buildPreviewIcon(BuildContext context) {
    if (content is Uri) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: SizedBox.square(
          dimension: 48,
          child: Icon(
            Icons.link_rounded,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
