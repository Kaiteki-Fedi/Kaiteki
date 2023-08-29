import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/user_resolver.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/model.dart";
import "package:logging/logging.dart";

Future<void> resolveAndOpenUser(
  UserReference user,
  BuildContext context,
  WidgetRef ref,
) async {
  final handle = user.toString();
  final messenger = ScaffoldMessenger.of(context);
  // final lookupSnackbar = messenger.showSnackBar(
  //   SnackBar(content: Text("Looking up $handle...")),
  // );
  ref
      .read(
    resolveProvider(
      ref.watch(currentAccountProvider)!.key,
      user,
    ).future,
  )
      .then((user) async {
    // lookupSnackbar.close();
    if (user == null) {
      messenger.showSnackBar(
        SnackBar(content: Text("Couldn't find $handle")),
      );
      return;
    }
    await context.showUser(user, ref);
  }).catchError((e) {
    Logger("resolveAndOpenUser").warning("Failed to resolve handle $handle", e);

    messenger.showSnackBar(
      SnackBar(content: Text("Failed to resolve $handle")),
    );
  });
}
