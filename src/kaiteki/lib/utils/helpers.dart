import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
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
  final adapter = ref.read(adapterProvider);
  user.resolve(adapter).then((user) async {
    // lookupSnackbar.close();
    if (user == null) throw Exception("User not found");
    await context.showUser(user, ref);
  }).catchError((e) {
    Logger("resolveAndOpenUser").warning("Failed to resolve handle $handle", e);

    messenger.showSnackBar(
      SnackBar(content: Text("Failed to resolve $handle")),
    );
  });
}
