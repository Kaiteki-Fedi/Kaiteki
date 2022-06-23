import 'package:flutter/material.dart' hide Element;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:kaiteki/utils/text/elements.dart';
import 'package:kaiteki/utils/text/parsers.dart';

class TextRenderDialog extends ConsumerStatefulWidget {
  final Post post;

  const TextRenderDialog(this.post, {Key? key}) : super(key: key);

  @override
  ConsumerState<TextRenderDialog> createState() => _TextRenderDialogState();
}

class _TextRenderDialogState extends ConsumerState<TextRenderDialog> {
  TextRenderDialogView _view = TextRenderDialogView.raw;

  @override
  Widget build(BuildContext context) {
    final Widget content;

    switch (_view) {
      case TextRenderDialogView.raw:
        content = _buildRaw();
        break;
      case TextRenderDialogView.parsed:
        content = _buildParsed();
        break;
      case TextRenderDialogView.rendered:
        content = _buildRendered();
        break;
    }

    return AlertDialog(
      title: const Text("Text rendering"),
      content: SizedBox(
        width: 800,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text("Raw"),
                  selected: _view == TextRenderDialogView.raw,
                  onSelected: (_) => setState(() {
                    _view = TextRenderDialogView.raw;
                  }),
                ),
                FilterChip(
                  label: const Text("Parsed"),
                  selected: _view == TextRenderDialogView.parsed,
                  onSelected: (_) => setState(() {
                    _view = TextRenderDialogView.parsed;
                  }),
                ),
                FilterChip(
                  label: const Text("Rendered"),
                  selected: _view == TextRenderDialogView.rendered,
                  onSelected: (_) => setState(() {
                    _view = TextRenderDialogView.rendered;
                  }),
                ),
              ],
            ),
            const SizedBox(height: 7),
            Flexible(child: content),
          ],
        ),
      ),
    );
  }

  String getTree(Element element) {
    var a = element.toString();

    final children = element.children;
    if (children != null) {
      for (final child in children) {
        final childResult = getTree(child);
        a += "\n$childResult";
      }
    }

    return a.split("\n").join("\n⮩ ");
  }

  Widget _buildRaw() {
    return TextField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
      style: GoogleFonts.robotoMono(),
      controller: TextEditingController(text: widget.post.content),
      readOnly: true,
      maxLines: null,
    );
  }

  Widget _buildParsed() {
    final elements = const MastodonHtmlTextParser()
        .parse(widget.post.content!)
        .parseWith(const SocialTextParser())
        .parseWith(const MfmTextParser());

    return TextField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
      ),
      style: GoogleFonts.robotoMono(),
      controller: TextEditingController(
        text: elements.map(getTree).join("\n"),
      ),
      readOnly: true,
      maxLines: null,
    );
  }

  Widget _buildRendered() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).disabledColor,
        ),
        borderRadius: BorderRadius.circular(6.0),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Text.rich(
        widget.post.renderContent(context),
      ),
    );
  }
}

enum TextRenderDialogView { raw, parsed, rendered }
