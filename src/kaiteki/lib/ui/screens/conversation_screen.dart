import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/ui/widgets/post_widget.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:kaiteki/utils/layout_helper.dart';
import 'package:kaiteki/utils/threader.dart';
import 'package:mdi/mdi.dart';

class ConversationScreen extends ConsumerStatefulWidget {
  final Post post;

  const ConversationScreen(this.post, {Key? key}) : super(key: key);

  @override
  ConsumerState<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  late Future<Iterable<Post>> _threadFetchFuture;
  bool showThreaded = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final adapter = ref.watch(accountProvider).adapter;
    _threadFetchFuture = adapter.getThread(widget.post.getRoot());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.getL10n();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.conversationTitle),
        actions: [
          IconButton(
            icon: Icon(showThreaded ? Mdi.fileTree : Mdi.fileTreeOutline),
            onPressed: () => setState(() => showThreaded = !showThreaded),
          ),
        ],
      ),
      body: ResponsiveLayoutBuilder(
        builder: (context, constraints, data) {
          return showThreaded ? buildThreaded(context) : buildFlat(context);
        },
      ),
    );
  }

  Widget buildThreaded(BuildContext context) {
    final future = _threadFetchFuture.then((thread) {
      return compute(toThread, thread.toList(growable: false));
    });

    final l10n = context.getL10n();

    return FutureBuilder<ThreadPost>(
      future: future,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            child: ThreadPostContainer(snapshot.data!),
          );
        } else if (snapshot.hasError) {
          return Column(
            children: [
              StatusWidget(widget.post),
              ListTile(
                leading: const Icon(Mdi.close),
                title: Text(l10n.threadRetrievalFailed),
                subtitle: Text(snapshot.error.toString()),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buildFlat(BuildContext context) {
    final l10n = context.getL10n();

    return FutureBuilder<Iterable<Post>>(
      future: _threadFetchFuture,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final post = snapshot.data!.elementAt(index);
              return StatusWidget(post);
            },
          );
        } else if (snapshot.hasError) {
          return Column(
            children: [
              StatusWidget(widget.post),
              ListTile(
                leading: const Icon(Mdi.close),
                title: Text(l10n.threadRetrievalFailed),
                subtitle: Text(snapshot.error.toString()),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
