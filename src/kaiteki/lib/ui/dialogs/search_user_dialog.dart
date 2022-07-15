import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/ui/shared/posts/avatar_widget.dart';
import 'package:mdi/mdi.dart';

class SearchUserDialog extends ConsumerStatefulWidget {
  const SearchUserDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchUserDialog> createState() => _SearchUserDialogState();
}

class _SearchUserDialogState extends ConsumerState<SearchUserDialog> {
  Future<Iterable<User>>? _future;

  @override
  Widget build(BuildContext context) {
    final manager = ref.watch(accountProvider);
    // final adapter = manager.adapter;

    return AlertDialog(
      title: const Text("Search user"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(
              suffixIcon: Icon(Mdi.magnify),
              hintText: "Enter an username",
              border: OutlineInputBorder(),
            ),
            onChanged: (query) {
              // _future = adapter.findUsers();
            },
          ),
          const SizedBox(height: 12.0),
          Flexible(
            child: SizedBox(
              width: 380,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: FutureBuilder<Iterable<User>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final results = snapshot.data!;

                    if (results.isEmpty) {
                      return const ListTile(title: Text("No results found"));
                    }

                    return ListTileTheme(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            for (var i = 0; i < 1; i++)
                              _UserListTile(manager.currentAccount.account),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserListTile extends StatelessWidget {
  final User user;

  const _UserListTile(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: AvatarWidget(user, size: 32),
      title: Text(user.displayName),
      subtitle: Text(user.host ?? user.username),
      onTap: () => Navigator.of(context).pop(user),
    );
  }
}
