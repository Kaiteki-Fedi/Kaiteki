import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_preferences.dart" as preferences;
import "package:kaiteki/preferences/content_warning_behavior.dart";
import "package:kaiteki/ui/shared/posts/attachment_row.dart";
import "package:kaiteki/ui/shared/posts/embed_widget.dart";
import "package:kaiteki/ui/shared/posts/embedded_post.dart";
import "package:kaiteki/ui/shared/posts/poll_widget.dart";
import "package:kaiteki/ui/shared/posts/post_widget.dart";
import "package:kaiteki/ui/shared/posts/subject_bar.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/model.dart";

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (subject != null && subject.isNotEmpty == true)
          SubjectBar(
            subject: post.subject!,
            collapsed: collapsed,
            onTap: () => setState(() => collapsed = !collapsed),
          ),
        if (hasContent && !collapsed)
          Padding(
            padding: kPostPadding,
            child: SelectableText.rich(
              TextSpan(children: [renderedContent!]),
              // FIXME(Craftplacer): https://github.com/flutter/flutter/issues/53797
              onTap: widget.onTap,
              style: widget.style,
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
        if (post.quotedPost != null) EmbeddedPostWidget(post.quotedPost!),
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
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _renderContent();

    final cwBehavior = ref.watch(preferences.cwBehavior).value;

    final subject = widget.post.subject;
    final hasSubject = subject != null && subject.isNotEmpty;

    if (hasSubject) {
      switch (cwBehavior) {
        case ContentWarningBehavior.collapse:
          collapsed = true;
          break;
        case ContentWarningBehavior.expanded:
          collapsed = false;
          break;
        case ContentWarningBehavior.automatic:
          final plainText = renderedContent?.toPlainText(
            includeSemanticsLabels: false,
            includePlaceholders: false,
          );

          final strings = [if (plainText != null) plainText, subject];

          if (strings.isEmpty) break;

          final words = strings
              .map((e) => e.toLowerCase())
              .map((e) => e.split(RegExp(r"([\s:])+")))
              .flattened;

          collapsed = sensitiveWords.any(words.contains);
          break;
      }
    }
  }

  void _renderContent() {
    final post = widget.post;

    if (post.content == null) {
      renderedContent = null;
    } else {
      renderedContent = post.renderContent(
        context,
        ref,
        showReplyees: widget.showReplyee ?? true,
      );
    }
  }
}
