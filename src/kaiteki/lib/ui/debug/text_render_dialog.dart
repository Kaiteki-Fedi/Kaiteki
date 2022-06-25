import 'package:flutter/material.dart' hide Element;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
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

    return TreeView(
      nodes: elements.map(_buildNode).toList(growable: false),
      indent: 28,
    );
  }

  TreeNode _buildNode(Element element) {
    return TreeNode(
      children: element.children?.isNotEmpty == true
          ? element.children?.map(_buildNode).toList(growable: false)
          : null,
      content: Flexible(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              color: Theme.of(context).colorScheme.primary,
              _getElementIcon(element),
            ),
            const SizedBox(width: 8),
            Flexible(child: Text(element.toString())),
          ],
        ),
      ),
    );
  }

  IconData _getElementIcon(Element element) {
    if (element is LinkElement) return Icons.link_rounded;
    if (element is MentionElement) return Icons.alternate_email_rounded;
    if (element is TextElement) return Icons.short_text_rounded;
    if (element is EmojiElement) return Icons.insert_emoticon_rounded;
    if (element is HashtagElement) return Icons.tag_rounded;
    return Icons.square_rounded;
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
