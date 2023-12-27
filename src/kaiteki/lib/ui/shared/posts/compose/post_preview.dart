import "package:async/async.dart";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/services/emoji.dart";
import "package:kaiteki/text/elements.dart";
import "package:kaiteki/text/parsers/social_text_parser.dart";
import "package:kaiteki/text/text_context.dart";
import "package:kaiteki/text/text_renderer.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/social.dart";
import "package:kaiteki_core/utils.dart";

class PostPreview extends ConsumerStatefulWidget {
  final PostDraft draft;

  const PostPreview({
    super.key,
    required this.draft,
  });

  @override
  ConsumerState<PostPreview> createState() => _PostPreviewState();
}

typedef _PostPreviewData = ({Post post, bool local});

class _PostPreviewState extends ConsumerState<PostPreview> {
  Future<_PostPreviewData>? _future;
  Key? _futureBuilderKey;
  late final RestartableTimer _timer;

  @override
  void initState() {
    super.initState();

    _timer = RestartableTimer(const Duration(seconds: 1), _updatePreview);

    ref.listenManual(
      adapterProvider,
      (_, __) => _updatePreview(),
      fireImmediately: true,
    );
  }

  void _updatePreview() {
    if (widget.draft.isEmpty) {
      setState(() => _future = null);
      return;
    }

    final previewInterface =
        ref.read(adapterProvider).safeCast<PreviewSupport>();

    setState(() {
      _futureBuilderKey = UniqueKey();

      if (previewInterface != null) {
        _future = previewInterface
            .getPreview(widget.draft)
            .then((post) => (post: post, local: false));
        return;
      }

      final needsRemoteData =
          const SocialTextParser().parse(widget.draft.content).any(
                (element) => element.has((element) => element is EmojiElement),
              );

      final account = ref.read(currentAccountProvider);
      if (needsRemoteData && account != null) {
        _future = () async {
          final categories = await ref.read(
            emojiServiceProvider(account.key).future,
          );
          final emojis = categories.map((e) => e.emojis).flattened.toList();
          final modifiedPost = post.copyWith(emojis: emojis);
          return (post: modifiedPost, local: true);
        }();
      } else {
        _future = null;
      }
    });

    _timer.cancel();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PostPreview oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.draft == oldWidget.draft) return;

    // Reset the timer if the adapter supports previews, otherwise update the
    // preview immediately.
    if (ref.read(adapterProvider) is PreviewSupport) {
      _timer.reset();
    } else {
      _updatePreview();
    }
  }

  /// Generates a post using client-side text parsing.
  Post get post {
    return Post(
      postedAt: DateTime.now(),
      author: ref.read(currentAccountProvider)!.user,
      id: "preview",
      content: widget.draft.content,
      subject: widget.draft.subject,
      formatting: widget.draft.formatting,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_PostPreviewData>(
      key: _futureBuilderKey,
      future: _future,
      initialData: (post: post, local: true),
      builder: (context, snapshot) {
        final l10n = context.l10n;

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Failed to generate preview: ${snapshot.error}",
              style: Theme.of(context).colorScheme.outline.textStyle,
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: centeredCircularProgressIndicator,
          );
        }
        final data = snapshot.data!;

        final content = data.post.content;

        if (widget.draft.isEmpty || content == null) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              l10n.postPreviewWaiting,
              style: Theme.of(context).colorScheme.outline.textStyle,
            ),
          );
        }

        final renderer = TextRenderer.fromContext(
          context,
          ref,
          TextContext(
            emojiResolver: (e) => resolveEmoji(
              e,
              ref,
              ref.read(currentAccountProvider)?.user.host,
              snapshot.data!.post.emojis,
            ),
          ),
        );

        final parsed = parseText(
          content,
          ref.read(textParserProvider),
        );

        Widget child = Text.rich(renderer.render(parsed));

        if (snapshot.connectionState == ConnectionState.active) {
          child = Opacity(opacity: 0.75, child: child);
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: AnimatedSwitcher(
            layoutBuilder: _switcherLayoutBuilder,
            duration: const Duration(milliseconds: 200),
            child: child,
          ),
        );
      },
    );
  }
}

Widget _switcherLayoutBuilder(
  Widget? currentChild,
  List<Widget> previousChildren,
) {
  return Stack(
    alignment: Alignment.topLeft,
    children: <Widget>[
      ...previousChildren,
      if (currentChild != null) currentChild,
    ],
  );
}
