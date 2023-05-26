import "package:animations/animations.dart";
import "package:flutter/material.dart";
import "package:fpdart/fpdart.dart" hide State;
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/interfaces/list_support.dart";
import "package:kaiteki/fediverse/model/model.dart";
import "package:kaiteki/ui/shared/app_bar_tab_bar_theme.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/dialogs/find_user_dialog.dart";
import "package:kaiteki/ui/shared/icon_landing_widget.dart";
import "package:kaiteki/ui/shared/posts/user_list_dialog.dart";
import "package:kaiteki/ui/shared/timeline.dart";
import "package:kaiteki/utils/extensions.dart";

class ListsScreen extends ConsumerStatefulWidget {
  const ListsScreen({super.key});

  @override
  ConsumerState<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends ConsumerState<ListsScreen> {
  bool _editMode = false;
  final _progressIndicatorKey = GlobalKey();
  Future<List<PostList>>? _future;

  @override
  void initState() {
    super.initState();
    ref.listenManual(
      adapterProvider,
      (_, adapter) {
        final lists = adapter as ListSupport?;
        if (lists == null) return;
        setState(() {
          _future = lists.getLists();
        });
      },
      fireImmediately: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    // final isLandscape = MediaQuery.of(context).size.width >= 600;
    return Option<ListSupport>.safeCast(ref.watch(adapterProvider)).match(
      () => Scaffold(
        appBar: AppBar(title: const Text("Lists")),
        body: const Center(
          child: IconLandingWidget(
            icon: Icon(Icons.list_alt_rounded),
            text: Text("Your instance doesn't seem to support lists"),
          ),
        ),
      ),
      (adapter) => FutureBuilder<List<PostList>>(
        future: _future,
        builder: (context, snapshot) {
          // Widget body;
          //
          // if (_editMode) {
          //   body = _buildEdit(snapshot);
          // } else {
          //   body = isLandscape
          //       ? _buildViewLandscape(context, snapshot)
          //       : _buildView(snapshot, adapter);
          // }

          return AppBarTabBarTheme(
            child: DefaultTabController(
              length: snapshot.data?.length ?? 0,
              child: _editMode
                  ? _buildEdit(snapshot)
                  : _buildView(snapshot, adapter),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEdit(AsyncSnapshot<List<PostList>> snapshot) {
    final isLoading = snapshot.connectionState == ConnectionState.waiting;

    final appBar = AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close_rounded),
        tooltip: "Exit edit mode",
        onPressed: () => setState(() => _editMode = false),
      ),
      title: const Text("Edit lists"),
    );
    return Scaffold(
      appBar: isLoading
          ? LinearProgressIndicatorOverlay(
              key: _progressIndicatorKey,
              child: appBar,
            )
          : appBar,
      floatingActionButton: FloatingActionButton(
        onPressed: _onCreateList,
        tooltip: "Create list",
        child: const Icon(Icons.add_rounded),
      ),
      body: snapshot.data.nullTransform(
        (lists) => lists.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                primary: true,
                itemCount: lists.length,
                padding: const EdgeInsets.all(8.0),
                itemBuilder: (context, index) {
                  final list = lists[index];
                  return _ListCard(
                    list,
                    onDelete: _updateLists,
                    onRename: _updateLists,
                  );
                },
              ),
      ),
    );
  }

  Widget _buildViewLandscape(
    BuildContext context,
    AsyncSnapshot<List<PostList>> snapshot,
  ) {
    final lists = snapshot.data;
    final isLoading = snapshot.connectionState == ConnectionState.waiting;
    final listsAvailable = lists != null && lists.isNotEmpty;

    final appBar = AppBar(
      title: const Text("Lists"),
      actions: [
        if (listsAvailable)
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            tooltip: "Edit lists",
            onPressed: () => setState(() => _editMode = true),
          ),
      ],
    );

    final Widget body;

    if (isLoading) {
      body = const SizedBox();
    } else if (listsAvailable) {
      body = TabBarView(
        children: [
          for (final list in lists) Timeline.list(listId: list.id),
        ],
      );
    } else {
      body = _buildEmptyState();
    }

    return Scaffold(
      body: isLoading
          ? centeredCircularProgressIndicator
          : Row(
              children: [
                SizedBox(
                  width: 300,
                  child: Column(
                    children: [
                      appBar,
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            return NavigationDrawer(
                              elevation: 0,
                              onDestinationSelected: (index) {
                                DefaultTabController.of(context)
                                    .animateTo(index);
                              },
                              children: [
                                if (lists != null)
                                  for (final list in lists)
                                    NavigationDrawerDestination(
                                      icon: const Icon(Icons.list_alt_rounded),
                                      label: Text(list.name),
                                    ),
                              ],
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: PageTransitionSwitcher(
                    transitionBuilder: (
                      child,
                      animation,
                      secondaryAnimation,
                    ) {
                      return FadeThroughTransition(
                        animation: animation,
                        secondaryAnimation: secondaryAnimation,
                        child: child,
                      );
                    },
                    child: body,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildView(
    AsyncSnapshot<List<PostList>> snapshot,
    ListSupport adapter,
  ) {
    final lists = snapshot.data;
    final isLoading = snapshot.connectionState == ConnectionState.waiting;
    final listsAvailable = lists != null && lists.isNotEmpty;

    final appBar = AppBar(
      title: const Text("Lists"),
      actions: [
        if (listsAvailable)
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            tooltip: "Edit lists",
            onPressed: () => setState(() => _editMode = true),
          ),
      ],
      bottom: isLoading || lists?.isNotEmpty != true
          ? null
          : TabBar(
              isScrollable: true,
              tabs: [
                if (lists != null)
                  for (final list in lists) Tab(text: list.name),
              ],
            ),
    );

    final Widget body;

    if (isLoading) {
      body = const SizedBox();
    } else if (listsAvailable) {
      body = TabBarView(
        children: [
          for (final list in lists) Timeline.list(listId: list.id),
        ],
      );
    } else {
      body = _buildEmptyState();
    }

    return Scaffold(
      appBar: isLoading
          ? LinearProgressIndicatorOverlay(
              key: _progressIndicatorKey,
              child: appBar,
            )
          : appBar,
      body: Column(
        children: [
          if (Theme.of(context).useMaterial3 && listsAvailable) const Divider(),
          Expanded(
            child: PageTransitionSwitcher(
              transitionBuilder: (
                child,
                animation,
                secondaryAnimation,
              ) {
                return FadeThroughTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                );
              },
              child: body,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const IconLandingWidget(
            icon: Icon(Icons.list_alt_outlined),
            text: Text("No lists"),
          ),
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: _onCreateList,
            child: const Text("Create List"),
          ),
        ],
      ),
    );
  }

  Future<void> _onCreateList() async {
    final answer = await showDialog<String>(
      context: context,
      builder: (_) => const NameListDialog(),
    );

    if (answer?.isNotEmpty != true) return;
    if (!mounted) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final listAdapter = ref.read(adapterProvider) as ListSupport;

    final controller = scaffoldMessenger.showSnackBar(
      SnackBar(content: Text("Creating $answer...")),
    );

    try {
      await listAdapter.createList(answer!);
      _updateLists();
    } finally {
      controller.close();
    }
  }

  void _updateLists() {
    final adapter = ref.read(adapterProvider) as ListSupport;
    setState(() {
      _future = adapter.getLists();
    });
  }
}

class _ListCard extends ConsumerStatefulWidget {
  final PostList list;
  final VoidCallback onDelete;
  final VoidCallback onRename;

  const _ListCard(this.list, {required this.onDelete, required this.onRename});

  @override
  ConsumerState<_ListCard> createState() => _ListCardState();
}

class _ListCardState extends ConsumerState<_ListCard> {
  Future<List<User>>? _future;

  @override
  Widget build(BuildContext context) {
    final listAdapter = ref.read(adapterProvider) as ListSupport;
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0.0,
      borderOnForeground: false,
      shape: Theme.of(context).useMaterial3
          ? null
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
              side: BorderSide(
                color: Theme.of(context).dividerColor,
              ),
            ),
      margin: const EdgeInsets.all(8.0),
      color: Theme.of(context).useMaterial3
          ? Theme.of(context).colorScheme.surfaceVariant
          : null,
      child: ExpansionTile(
        title: Text(widget.list.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.drive_file_rename_outline_rounded),
              tooltip: "Rename list",
              onPressed: () async {
                final answer = await showDialog<String>(
                  context: context,
                  builder: (_) => NameListDialog(name: widget.list.name),
                );

                if (answer?.isNotEmpty != true) return;
                if (answer == widget.list.name) return;
                if (!mounted) return;

                //final scaffoldMessenger = ScaffoldMessenger.of(context);
                final listAdapter = ref.read(adapterProvider) as ListSupport;

                try {
                  await listAdapter.renameList(widget.list.id, answer!);
                  widget.onRename();
                } catch (e, _) {
                  rethrow;
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_rounded),
              tooltip: "Delete list",
              onPressed: _onDeleteList,
            ),
          ],
        ),
        children: [
          const Divider(),
          FutureBuilder<List<User>>(
            future: _future ??= listAdapter.getListUsers(widget.list.id),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return centeredCircularProgressIndicator;

              return ListView.separated(
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return ListTile(
                      leading: const Icon(Icons.add_rounded),
                      title: Text("Add user to ${widget.list.name}"),
                      onTap: _onAddUser,
                    );
                  }

                  index--;

                  final user = snapshot.data![index];
                  return UserListTile(
                    user: user,
                    onPressed: () => context.showUser(user, ref),
                    trailing: [
                      IconButton(
                        splashRadius: 24,
                        icon: const Icon(Icons.close),
                        onPressed: () => _onRemoveUser(user),
                        tooltip: "Remove from list",
                      ),
                    ],
                  );
                },
                shrinkWrap: true,
                itemCount: (snapshot.data?.length ?? 0) + 1,
              );
            },
          ),
        ],
      ),
    );
  }

  void _refreshList() {
    final listAdapter = ref.read(adapterProvider) as ListSupport;
    setState(() {
      _future = listAdapter.getListUsers(widget.list.id);
    });
  }

  Future<void> _onAddUser() async {
    final user = await showDialog<User>(
      context: context,
      builder: (context) => const FindUserDialog(),
    );

    if (user == null) return;

    final listAdapter = ref.read(adapterProvider) as ListSupport;
    await listAdapter.addUserToList(widget.list.id, user);

    _refreshList();
  }

  Future<void> _onRemoveUser(User user) async {
    // TODO(Craftplacer): Add "undo" to snack bar
    final listAdapter = ref.read(adapterProvider) as ListSupport;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      await listAdapter.removeUserFromList(widget.list.id, user);
      if (!mounted) return;
      // TODO(Craftplacer): https://github.com/Kaiteki-Fedi/Kaiteki/issues/260
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text.rich(
            TextSpan(
              text: "Removed ",
              children: [
                user.renderDisplayName(context, ref),
                TextSpan(text: " from ${widget.list.name}")
              ],
            ),
          ),
        ),
      );
    } catch (e, s) {
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text.rich(
            TextSpan(
              text: "There was a problem removing ",
              children: [
                user.renderDisplayName(context, ref),
                TextSpan(text: " from ${widget.list.name}")
              ],
            ),
          ),
          action: SnackBarAction(
            label: context.l10n.whyButtonLabel,
            onPressed: () => context.showExceptionDialog((e, s)),
          ),
        ),
      );
    }

    _refreshList();
  }

  Future<void> _onDeleteList() async {
    final response = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete list?"),
          content: const Text(
            "The list will be deleted permanently",
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (response != true) return;
    if (!mounted) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      final listAdapter = ref.read(adapterProvider) as ListSupport;
      await listAdapter.deleteList(widget.list.id);

      widget.onDelete();

      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text("Removed ${widget.list.name}")),
      );
    } catch (e, s) {
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(
            "There was a problem removing ${widget.list.name}",
          ),
          action: SnackBarAction(
            label: context.l10n.whyButtonLabel,
            onPressed: () => context.showExceptionDialog((e, s)),
          ),
        ),
      );
    }
  }
}

class LinearProgressIndicatorOverlay extends StatelessWidget
    implements PreferredSizeWidget {
  final PreferredSizeWidget child;
  final double? value;

  const LinearProgressIndicatorOverlay({
    super.key,
    required this.child,
    this.value,
  });

  @override
  Size get preferredSize => child.preferredSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: LinearProgressIndicator(
            value: value,
          ),
        ),
      ],
    );
  }
}

class NameListDialog extends StatefulWidget {
  final String? name;

  const NameListDialog({super.key, this.name});

  @override
  State<NameListDialog> createState() => _NameListDialogState();
}

class _NameListDialogState extends State<NameListDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final create = widget.name == null;
    return AlertDialog(
      title: create ? const Text("Create new list") : const Text("Rename list"),
      content: TextField(
        controller: _controller,
        onSubmitted: _onConfirm,
        decoration: const InputDecoration(
          labelText: "Name",
          border: OutlineInputBorder(),
        ),
        textInputAction: TextInputAction.done,
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: _onCancel,
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: _onConfirm,
          child: create ? const Text("Create") : const Text("Rename"),
        ),
      ],
    );
  }

  void _onCancel() => Navigator.of(context).pop();

  void _onConfirm([String? name]) {
    Navigator.of(context).pop(name ?? _controller.text);
  }
}
