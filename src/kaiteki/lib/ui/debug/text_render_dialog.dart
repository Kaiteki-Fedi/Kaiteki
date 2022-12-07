import 'package:flutter/material.dart' hide Element;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/theming/kaiteki/text_theme.dart';
import 'package:kaiteki/ui/shared/dialogs/dialog_close_button.dart';
import 'package:kaiteki/ui/shared/dialogs/dynamic_dialog_container.dart';
import 'package:kaiteki/ui/shared/primary_tab_bar_theme.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:kaiteki/utils/text/elements.dart';
import 'package:kaiteki/utils/text/parsers.dart';

class TextRenderDialog extends ConsumerStatefulWidget {
  final Post post;

  const TextRenderDialog(this.post, {super.key});

  @override
  ConsumerState<TextRenderDialog> createState() => _TextRenderDialogState();
}

class _TextRenderDialogState extends ConsumerState<TextRenderDialog> {
  @override
  Widget build(BuildContext context) {
    return DynamicDialogContainer(
      builder: (context, fullscreen) {
        final closeButton = DialogCloseButton(
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
        );
        return DefaultTabController(
          length: 3,
          child: SizedBox(
            width: 800,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  title: const Text("Text rendering"),
                  actions: [if (!fullscreen) closeButton],
                  leading: fullscreen ? closeButton : null,
                  elevation: 0,
                  backgroundColor: Theme.of(context).colorScheme.background,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: TabBar(
                    isScrollable: true,
                    tabs: [
                      Tab(text: "Raw"),
                      Tab(text: "Parsed"),
                      Tab(text: "Rendered"),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12.0,
                    ),
                    child: TabBarView(
                      children: [
                        _buildRaw(),
                        _buildParsed(),
                        _buildRendered(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRaw() {
    return SelectableText(
      widget.post.content ?? "",
      style: GoogleFonts.robotoMono(),
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
            Column(
              children: [
                Icon(
                  color: Theme.of(context).colorScheme.primary,
                  _getElementIcon(element),
                ),
                if (element is TextElement &&
                    element.style?.font == TextElementFont.monospace)
                  Text(
                    "mono",
                    style: Theme.of(context).ktkTextTheme?.monospaceTextStyle,
                    textScaleFactor: 0.75,
                  ),
              ],
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
    return Text.rich(
      widget.post.renderContent(context, ref),
    );
  }
}

enum TextRenderDialogView { raw, parsed, rendered }
