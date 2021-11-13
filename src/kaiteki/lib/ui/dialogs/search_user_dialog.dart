import 'package:flutter/material.dart';
import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/ui/widgets/posts/avatar_widget.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/src/provider.dart';

class SearchUserDialog extends StatefulWidget {
  SearchUserDialog({Key? key}) : super(key: key);

  @override
  State<SearchUserDialog> createState() => _SearchUserDialogState();
}

class _SearchUserDialogState extends State<SearchUserDialog> {
  Future<Iterable<User>>? _future;

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<AccountManager>();
    final adapter = manager.adapter;

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
                child: FutureBuilder(
                  future: _future,
                  builder: (context, AsyncSnapshot<Iterable<User>> snapshot) {
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
      onTap: () => _onTap(context),
    );
  }

  void _onTap(context) {
    final navigator = Navigator.of(context);
    navigator.pop(user);
  }
}
