// ignore_for_file: l10n
import "package:flutter/material.dart" hide Element;
import "package:flutter_simple_treeview/flutter_simple_treeview.dart";
import "package:google_fonts/google_fonts.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/text/elements.dart";
import "package:kaiteki/text/parsers.dart";
import "package:kaiteki/text/parsers/md_text_parser.dart";
import "package:kaiteki/text/text_renderer.dart";
import "package:kaiteki/ui/shared/dialogs/dialog_close_button.dart";
import "package:kaiteki/ui/shared/dialogs/dynamic_dialog_container.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/model.dart";
import "package:kaiteki_core/utils.dart";
import "package:mdi/mdi.dart";

class TextRenderDialog extends ConsumerStatefulWidget {
  final Post post;

  const TextRenderDialog(this.post, {super.key});

  @override
  ConsumerState<TextRenderDialog> createState() => _TextRenderDialogState();
}

class _TextRenderDialogState extends ConsumerState<TextRenderDialog> {
  static const _padding = EdgeInsets.symmetric(
    horizontal: 24.0,
    vertical: 12.0,
  );

  @override
  Widget build(BuildContext context) {
    return DynamicDialogContainer(
      builder: (context, fullscreen) {
        final closeButton = DialogCloseButton(
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
        );
        return DefaultTabController(
          length: 4,
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
                      Tab(text: "Parsers"),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildRaw(),
                      _buildParsed(),
                      _buildRendered(),
                      _ParsersTab(
                        parsers: ref.watch(textParserProvider).toList(),
                      ),
                    ],
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
    final content = widget.post.content;

    if (content == null) return const SizedBox.expand();

    return Padding(
      padding: _padding,
      child: SelectableText(
        content,
        style: GoogleFonts.robotoMono(),
      ),
    );
  }

  Widget _buildParsed() {
    final textParser = ref.watch(textParserProvider);
    final elements = parseText(widget.post.content!, textParser);
    return SingleChildScrollView(
      child: TreeView(
        nodes: elements.map(_buildNode).toList(growable: false),
        indent: 28,
      ),
    );
  }

  TreeNode _buildNode(Element element) {
    InlineSpan inlineLineBreaks(String text) {
      final textStyle = TextStyle(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      );
      final spans = <InlineSpan>[];

      while (true) {
        final index = text.indexOf("\n");

        if (index == -1) {
          spans.add(TextSpan(text: text));
          break;
        }

        spans
          ..add(TextSpan(text: text.substring(0, index)))
          ..add(TextSpan(text: r"\n", style: textStyle));

        text = text.substring(index + 1);
      }

      return TextSpan(children: spans);
    }

    InlineSpan getSpan(Element element) {
      switch (element) {
        case TextElement():
          return inlineLineBreaks(element.text);
        case TextStyleElement():
          final scale = element.style.scale;
          return TextSpan(
            text: [
              if (element.style.blur == true) "blur",
              if (scale != null && scale != 1.0) "scale: $scale",
              if (element.style.bold == true) "bold",
              if (element.style.italic == true) "italic",
              if (element.style.foreground != null)
                "foreground: ${element.style.foreground}",
              if (element.style.background != null)
                "background: ${element.style.background}",
              if (element.style.font != null) element.style.font?.name,
            ].join(", "),
          );
        default:
          return inlineLineBreaks(element.toString());
      }
    }

    final children = element.safeCast<WrapElement>()?.children;

    return TreeNode(
      children: children?.isNotEmpty == true
          ? children!.map(_buildNode).toList(growable: false)
          : null,
      content: Flexible(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(
            color: Theme.of(context).colorScheme.primary,
            _getElementIcon(element),
          ),
          dense: true,
          title: Text.rich(getSpan(element)),
          titleAlignment: ListTileTitleAlignment.top,
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
    if (element is TextStyleElement) return Icons.format_paint_rounded;
    return Icons.square_rounded;
  }

  Widget _buildRendered() {
    return SingleChildScrollView(
      padding: _padding,
      child: Text.rich(
        widget.post.renderContent(context, ref),
      ),
    );
  }
}

class _ParsersTab extends StatelessWidget {
  final List<TextParser> parsers;

  const _ParsersTab({required this.parsers});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: itemBuilder,
      itemCount: parsers.length,
      separatorBuilder: (_, __) {
        return const ListTile(
          enabled: false,
          leading: Icon(Icons.arrow_downward_rounded),
        );
      },
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    final parser = parsers[index];
    return ListTile(
      leading: switch (parser) {
        SocialTextParser() => const Icon(Icons.tag_rounded),
        MfmTextParser() => Image.asset(
            "assets/icons/misskey.png",
            cacheWidth: 24,
            cacheHeight: 24,
          ),
        MastodonHtmlTextParser() => Image.asset(
            "assets/icons/mastodon.png",
            cacheWidth: 24,
            cacheHeight: 24,
          ),
        HtmlTextParser() => const Icon(Icons.code_rounded),
        MarkdownTextParser() => const Icon(Mdi.languageMarkdown),
        TextParser() => const SizedBox.square(dimension: 24),
      },
      title: Text(parser.runtimeType.toString()),
    );
  }
}
