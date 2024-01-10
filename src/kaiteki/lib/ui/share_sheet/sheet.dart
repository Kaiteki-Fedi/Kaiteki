import "dart:io";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/share_sheet/share.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/kaiteki_core.dart";
import "package:share_plus/share_plus.dart";

enum SharableContentFormat { content, localLink, remoteLink }

Map<SharableContentFormat, Object> _getFormats(Object content) {
  return switch (content) {
    Post() => {
        if (content.content?.isNotEmpty == true)
          SharableContentFormat.content: content.content!,
        if (content.externalUrl != null)
          SharableContentFormat.remoteLink: content.externalUrl!,
      },
    _ => throw UnsupportedError("$content is not supported."),
  };
}

class ShareSheet extends StatefulWidget {
  final Object content;

  const ShareSheet(this.content, {super.key});

  @override
  State<ShareSheet> createState() => _ShareSheetState();
}

class _ShareSheetState extends State<ShareSheet> {
  SharableContentFormat _format = SharableContentFormat.remoteLink;
  late Map<SharableContentFormat, Object> _formats;

  @override
  void initState() {
    super.initState();
    _formats = _getFormats(widget.content);
  }

  @override
  Widget build(BuildContext context) {
    final hasNativeShareDialog = kIsWeb || Platform.isAndroid || Platform.isIOS;
    const margin = EdgeInsets.symmetric(horizontal: 16.0);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: margin,
          child: Text(
            "Share",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          padding: margin,
          scrollDirection: Axis.horizontal,
          child: _FormatSelector(
            selectedFormat: _format,
            formats: _formats,
            onChanged: (value) => setState(() => _format = value),
          ),
        ),
        const SizedBox(height: 8),
        Card.outlined(
          margin: margin,
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AnimatedSize(
              clipBehavior: Clip.none,
              duration: Durations.short4,
              child: buildPreviewBody(context),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Divider(),
        _ShareTargetOptions(
          onCompose: () {
            context.replaceNamed(
              "compose",
              pathParameters:
                  ProviderScope.containerOf(context).accountRouterParams,
              queryParameters: {"body": getShareText(widget.content)},
            );
          },
          // I don't know who over at flutter_community, thought people
          // would want to share stuff over their damn email client.
          onShare: hasNativeShareDialog
              ? () async {
                  final text = getShareText(widget.content);
                  await Share.share(text);
                }
              : null,
          onCopy: () => _copyToClipboard(context),
        ),
      ],
    );
  }

  Future<void> _copyToClipboard(BuildContext context) async {
    final text = getShareText(widget.content);
    final data = ClipboardData(text: text);
    await Clipboard.setData(data).then((_) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Copied to clipboard"),
        ),
      );
    });
  }

  Widget buildPreviewBody(BuildContext context) {
    final content = _formats[_format]!;
    return Text(content.toString(), maxLines: 2);
  }
}

class _ShareTargetOptions extends StatelessWidget {
  final VoidCallback? onCompose;
  final VoidCallback? onShare;
  final VoidCallback? onCopy;

  const _ShareTargetOptions({
    required this.onCompose,
    required this.onShare,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          if (onCompose != null)
            Expanded(
              child: _ShareTile(
                onTap: onCompose,
                icon: const Icon(Icons.edit_rounded),
                text: const Text("Compose"),
              ),
            ),
          if (onShare != null)
            Expanded(
              child: _ShareTile(
                onTap: onShare,
                icon: Icon(Icons.adaptive.share_rounded),
                text: Text(context.l10n.shareButtonLabel),
              ),
            ),
          if (onCopy != null)
            Expanded(
              child: _ShareTile(
                onTap: onCopy,
                icon: const Icon(Icons.copy_rounded),
                text: Text(context.l10n.copyToClipboardButtonTooltip),
              ),
            ),
        ],
      ),
    );
  }
}

class _FormatSelector extends StatelessWidget {
  final SharableContentFormat selectedFormat;
  final Map<SharableContentFormat, Object> formats;
  final ValueChanged<SharableContentFormat> onChanged;

  const _FormatSelector({
    required this.selectedFormat,
    required this.formats,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        for (final format in formats.keys)
          FilterChip(
            label: switch (format) {
              SharableContentFormat.content => Text(
                  context.l10n.shareSheetFormatContent,
                ),
              SharableContentFormat.localLink => Text(
                  context.l10n.shareSheetFormatLink,
                ),
              SharableContentFormat.remoteLink => Text(
                  context.l10n.shareSheetFormatRemoteLink(
                    (formats[SharableContentFormat.remoteLink] as Uri).host,
                  ),
                ),
            },
            onSelected: (_) => onChanged(format),
            selected: selectedFormat == format,
          ),
      ].joinWithValue(const SizedBox(width: 8)),
    );
  }
}

class _ShareTile extends StatelessWidget {
  final Widget icon;
  final Widget text;
  final VoidCallback? onTap;

  const _ShareTile({
    required this.icon,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final inverseSurface = Theme.of(context).colorScheme.inverseSurface;
    final inverseOnSurface = Theme.of(context).colorScheme.inverseOnSurface;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: inverseSurface,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconTheme(
                  data: IconThemeData(color: inverseOnSurface),
                  child: icon,
                ),
              ),
            ),
            const SizedBox(height: 8),
            DefaultTextStyle.merge(
              textAlign: TextAlign.center,
              child: text,
            ),
          ],
        ),
      ),
    );
  }
}
