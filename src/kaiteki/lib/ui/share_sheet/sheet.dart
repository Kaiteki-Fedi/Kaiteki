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
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              dragHandleInset,
              Text(
                "Share",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 16.0,
                ),
                child: Row(
                  children: [
                    buildPreviewIcon(context),
                    const SizedBox(width: 8),
                    Expanded(child: buildPreviewBody(context)),
                    const SizedBox(width: 8),
                    IconButton(
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
                      style: getIconButtonStyle(context),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: url.nullTransform(
                        (url) {
                          return () => launchUrl(url).then(
                                (_) => Navigator.of(context).pop(),
                              );
                        },
                      ),
                      icon: const Icon(Icons.open_in_new_rounded),
                      style: getIconButtonStyle(context, url != null),
                    ),
                  ],
                ),
              ),
              const Divider(),
              const SizedBox(height: 8),
              Consumer(
                builder: (context, ref, child) {
                  return ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text("Compose"),
                    onTap: () {
                      Navigator.of(context).pop();
                      context.pushNamed(
                        "compose",
                        params: ref.accountRouterParams,
                        queryParams: {"body": text},
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
      onClosing: () {},
    );
  }

  ButtonStyle getIconButtonStyle(BuildContext context, [bool enabled = true]) {
    final colorScheme = Theme.of(context).colorScheme;
    return IconButton.styleFrom(
      focusColor: colorScheme.onSurfaceVariant.withOpacity(0.12),
      highlightColor: colorScheme.onSurface.withOpacity(0.12),
      side: !enabled
          ? BorderSide(color: colorScheme.onSurface.withOpacity(0.12))
          : BorderSide(color: colorScheme.outline),
    ).copyWith(
      foregroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return colorScheme.onSurface;
        }
        return null;
      }),
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
