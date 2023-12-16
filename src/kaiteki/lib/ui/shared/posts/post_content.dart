import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_preferences.dart" as preferences;
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/preferences/content_warning_behavior.dart";
import "package:kaiteki/ui/shared/posts/attachment_row.dart";
import "package:kaiteki/ui/shared/posts/embed_widget.dart";
import "package:kaiteki/ui/shared/posts/embedded_post.dart";
import "package:kaiteki/ui/shared/posts/poll_widget.dart";
import "package:kaiteki/ui/shared/posts/post_widget.dart";
import "package:kaiteki/ui/shared/posts/subject_bar.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/kaiteki_core.dart";

class PostContent extends ConsumerStatefulWidget {
  final Post post;
  final bool? showReplyee;
  final VoidCallback? onTap;
  final TextStyle? style;

  const PostContent({
    super.key,
    required this.post,
    this.showReplyee,
    this.onTap,
    this.style,
  });

  @override
  ConsumerState<PostContent> createState() => _PostContentWidgetState();
}

class _PostContentWidgetState extends ConsumerState<PostContent> {
  InlineSpan? renderedContent;
  bool collapsed = false;

  bool get hasContent {
    return renderedContent != null &&
        renderedContent!.toPlainText().trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final subject = widget.post.subject;
    final locale = post.language.nullTransform(Locale.new);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (subject != null && subject.isNotEmpty == true)
          SubjectBar(
            subject: post.subject!,
            collapsed: collapsed,
            onTap: () => setState(() => collapsed = !collapsed),
          ),
        if (!collapsed) ...[
          if (hasContent)
            Padding(
              padding: kPostPadding,
              child: SelectableText.rich(
                TextSpan(
                  children: [renderedContent!],
                  locale: locale,
                ),
                // FIXME(Craftplacer): https://github.com/flutter/flutter/issues/53797
                onTap: widget.onTap,
                style: widget.style,
                textScaler: TextScaler.linear(ref.watch(postTextSize).value),
              ),
            ),
          if (post.poll != null) ...[
            const SizedBox(height: 8),
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: PollWidget.fromPost(
                post,
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
          if (post.attachments?.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            AttachmentRow(post: post),
          ],
          if (post.embeds.isNotEmpty) ...[
            const SizedBox(height: 8),
            Card(
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: <Widget>[
                  for (final embed in post.embeds) EmbedWidget(embed),
                ].joinWithValue(const Divider(height: 1)),
              ),
            ),
          ],
          if (post.quotedPost != null) ...[
            const SizedBox(height: 16),
            EmbeddedPostWidget(post.quotedPost!),
          ],
        ],
      ],
    );
  }

  @override
  void didUpdateWidget(covariant PostContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.post != widget.post) {
      _renderContent();
      _updateCollapsed();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _renderContent();
    _updateCollapsed();
  }

  void _updateCollapsed() {
    final cwBehavior = ref.watch(preferences.cwBehavior).value;

    final subject = widget.post.subject;
    final hasSubject = subject != null && subject.isNotEmpty;

    collapsed = switch (cwBehavior) {
      ContentWarningBehavior.collapse => hasSubject,
      ContentWarningBehavior.expanded => false,
      ContentWarningBehavior.automatic => _containsSensitiveWords(),
    };
  }

  bool _containsSensitiveWords() {
    final plainText = renderedContent?.toPlainText(
      includeSemanticsLabels: false,
      includePlaceholders: false,
    );

    final subject = widget.post.subject;

    final strings = [
      if (plainText != null) plainText,
      if (subject != null) subject,
    ];

    if (strings.isEmpty) return false;

    final words = strings
        .map((e) => e.toLowerCase())
        .map((e) => e.split(RegExp(r"([\s:])+")))
        .flattened;

    return sensitiveWords.any(words.contains);
  }

  void _renderContent() {
    final post = widget.post;

    if (post.content == null) {
      renderedContent = null;
    } else {
      try {
        renderedContent = post.renderContent(
          context,
          ref,
          showReplyees: widget.showReplyee ?? true,
        );
      } catch (e, s) {
        debugPrintStack(stackTrace: s, label: e.toString());
        renderedContent = TextSpan(text: post.content);
      }
    }
  }
}
