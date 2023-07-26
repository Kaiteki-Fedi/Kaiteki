import "package:anchor_scroll_controller/anchor_scroll_controller.dart";
import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/theme_preferences.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/posts/post_widget.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/model.dart";

class ConversationScreen extends ConsumerStatefulWidget {
  final Post post;

  const ConversationScreen(this.post, {super.key});

  @override
  ConsumerState<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  Future<Iterable<Post>>? _threadFetchFuture;
  // Future<ThreadPost>? _threadedFuture;
  bool showThreaded = true;
  late String selectedPostId;
  late final AnchorScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    selectedPostId = widget.post.id;
    _scrollController = AnchorScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final adapter = ref.watch(adapterProvider);
    try {
      _threadFetchFuture = adapter.getThread(widget.post.root);
      _threadFetchFuture!.then((list) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.scrollToIndex(
            index: list.toList().indexWhere((e) => e.id == selectedPostId),
          );
        });
      });
    } on UnimplementedError {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Fetching threads with ${adapter.type.displayName} is not implemented.",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.conversationTitle),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: buildFlat(context),
        ),
      ),
    );
  }

  // Widget buildThreaded(BuildContext context) {
  //   _threadedFuture ??= _threadFetchFuture?.then((thread) {
  //     return compute(toThread, thread.toList(growable: false));
  //   });

  //   return FutureBuilder<ThreadPost>(
  //     future: _threadedFuture,
  //     builder: (_, snapshot) {
  //       if (snapshot.hasData) {
  //         return SingleChildScrollView(
  //           child: ThreadPostContainer(snapshot.data!),
  //         );
  //       } else if (snapshot.hasError) {
  //         return Column(
  //           children: [
  //             PostWidget(widget.post, expanded: true),
  //             _buildErrorListTile(context, snapshot),
  //           ],
  //         );
  //       } else {
  //         return centeredCircularProgressIndicator;
  //       }
  //     },
  //   );
  // }

  Widget _buildErrorListTile(BuildContext context, AsyncSnapshot snapshot) {
    final l10n = context.l10n;
    return ListTile(
      leading: const Icon(Icons.error_rounded),
      title: Text(l10n.threadRetrievalFailed),
      trailing: OutlinedButton(
        child: const Text("Show details"),
        onPressed: () => context.showExceptionDialog(snapshot.traceableError!),
      ),
    );
  }

  Widget buildFlat(BuildContext context) {
    final useCards = ref.watch(usePostCards).value;
    return FutureBuilder<Iterable<Post>>(
      future: _threadFetchFuture,
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          return Column(
            children: [
              PostWidget(widget.post, layout: PostWidgetLayout.expanded),
              _buildErrorListTile(context, snapshot),
            ],
          );
        } else if (!snapshot.hasData) {
          return centeredCircularProgressIndicator;
        }

        final posts = snapshot.data!;

        if (useCards) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            // TODO(Craftplacer): might have to nag the flutter team to make this widget material you
            child: MergeableMaterial(
              hasDividers: true,
              elevation: Theme.of(context).useMaterial3 ? 0.0 : 2.0,
              children: posts
                  .mapIndexed((i, e) {
                    final preGapValue = Object.hash(e.id.hashCode, "before");
                    final afterGapValue = Object.hash(e.id.hashCode, "after");

                    final isSelected = e.id == selectedPostId;
                    return [
                      if (isSelected && i != 0)
                        MaterialGap(key: ValueKey(preGapValue)),
                      MaterialSlice(
                        key: ValueKey(e.id),
                        child: buildPost(i, e),
                        color: Theme.of(context).useMaterial3
                            ? ElevationOverlay.applySurfaceTint(
                                Theme.of(context).colorScheme.surface,
                                Theme.of(context).colorScheme.surfaceTint,
                                2.0,
                              )
                            : null,
                      ),
                      if (isSelected && i != (posts.length - 1))
                        MaterialGap(key: ValueKey(afterGapValue)),
                    ];
                  })
                  .flattened
                  .toList(),
            ),
          );
        }

        return ListView.separated(
          controller: _scrollController,
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts.elementAt(index);
            return buildPost(index, post);
          },
          separatorBuilder: (_, __) => const Divider(height: 1),
        );
      },
    );
  }

  AnchorItemWrapper buildPost(int index, Post post) {
    final isSelected = post.id == selectedPostId;

    return AnchorItemWrapper(
      index: index,
      controller: _scrollController,
      child: AnimatedCrossFade(
        crossFadeState:
            isSelected ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        firstChild: PostWidget(
          post,
          onOpen: () => setState(() => selectedPostId = post.id),
        ),
        secondChild: PostWidget(
          post,
          layout: PostWidgetLayout.expanded,
        ),
        duration: const Duration(milliseconds: 100),
      ),
    );
  }
}
