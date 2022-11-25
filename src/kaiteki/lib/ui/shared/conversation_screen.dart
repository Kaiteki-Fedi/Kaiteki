import 'package:breakpoint/breakpoint.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/ui/shared/layout/breakpoint_container.dart';
import 'package:kaiteki/ui/shared/posts/post_widget.dart';
import 'package:kaiteki/utils/extensions.dart';

import 'package:kaiteki/utils/threader.dart';

class ConversationScreen extends ConsumerStatefulWidget {
  final Post post;

  const ConversationScreen(this.post, {super.key});

  @override
  ConsumerState<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  Future<Iterable<Post>>? _threadFetchFuture;
  Future<ThreadPost>? _threadedFuture;
  bool showThreaded = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final adapter = ref.watch(adapterProvider);
    try {
      _threadFetchFuture = adapter.getThread(widget.post.getRoot());
    } on UnimplementedError {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Fetching threads with ${adapter.client.type.displayName} is not implemented.",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.getL10n();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.conversationTitle),
        actions: [
          IconButton(
            icon: Icon(
              showThreaded
                  ? Icons.view_timeline_rounded
                  : Icons.article_rounded,
            ),
            onPressed: () {
              setState(() {
                showThreaded = !showThreaded;
              });
            },
          ),
        ],
      ),
      body: BreakpointBuilder(
        builder: (context, breakpoint) {
          return BreakpointContainer(
            breakpoint: breakpoint,
            child: showThreaded ? buildThreaded(context) : buildFlat(context),
          );
        },
      ),
    );
  }

  Widget buildThreaded(BuildContext context) {
    _threadedFuture ??= _threadFetchFuture?.then((thread) {
      return compute(toThread, thread.toList(growable: false));
    });

    return FutureBuilder<ThreadPost>(
      future: _threadedFuture,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            child: ThreadPostContainer(snapshot.data!),
          );
        } else if (snapshot.hasError) {
          return Column(
            children: [
              PostWidget(widget.post, expand: true),
              _buildErrorListTile(context, snapshot),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildErrorListTile(BuildContext context, AsyncSnapshot snapshot) {
    final l10n = context.getL10n();
    return ListTile(
      leading: const Icon(Icons.error_rounded),
      title: Text(l10n.threadRetrievalFailed),
      trailing: OutlinedButton(
        child: const Text("Show details"),
        onPressed: () => context.showExceptionDialog(
          snapshot.error,
          snapshot.stackTrace,
        ),
      ),
    );
  }

  Widget buildFlat(BuildContext context) {
    return FutureBuilder<Iterable<Post>>(
      future: _threadFetchFuture,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return ListView.separated(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final post = snapshot.data!.elementAt(index);
              return PostWidget(
                post,
                expand: index == 0,
              );
            },
            separatorBuilder: (_, __) => const Divider(height: 1),
          );
        } else if (snapshot.hasError) {
          return Column(
            children: [
              PostWidget(widget.post, expand: true),
              _buildErrorListTile(context, snapshot),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
