import "package:anchor_scroll_controller/anchor_scroll_controller.dart";
import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/model/model.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/posts/post_widget.dart";
import "package:kaiteki/utils/extensions.dart";

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
    return FutureBuilder<Iterable<Post>>(
      future: _threadFetchFuture,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
            controller: _scrollController,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final post = snapshot.data!.elementAt(index);
              final isSelected = post.id == selectedPostId;
              return AnchorItemWrapper(
                index: index,
                controller: _scrollController,
                child: PostWidget(
                  post,
                  onOpen: isSelected
                      ? null
                      : () => setState(() => selectedPostId = post.id),
                  layout: isSelected
                      ? PostWidgetLayout.expanded
                      : PostWidgetLayout.normal,
                ),
              );
            },
            separatorBuilder: (_, __) => const Divider(height: 1),
          );
        } else if (snapshot.hasError) {
          return Column(
            children: [
              PostWidget(widget.post, layout: PostWidgetLayout.expanded),
              _buildErrorListTile(context, snapshot),
            ],
          );
        } else {
          return centeredCircularProgressIndicator;
        }
      },
    );
  }
}
