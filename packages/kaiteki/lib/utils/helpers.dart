import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/user_resolver.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/model.dart";
import "package:logging/logging.dart";
import "package:url_launcher/url_launcher.dart";

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
  final future = resolveProvider(
    ref.watch(currentAccountProvider)!.key,
    user,
  ).future;
  ref.read(future).then((result) async {
    // lookupSnackbar.close();
    switch (result) {
      case null:
        messenger.showSnackBar(
          SnackBar(content: Text("Couldn't find $handle")),
        );
      case ResolvedInternalUser():
        await context.showUser(result.user, ref);
      case ResolvedExternalUser():
        await launchUrl(result.url, mode: LaunchMode.externalApplication);
    }
  }).catchError((e) {
    Logger("resolveAndOpenUser").warning("Failed to resolve handle $handle", e);

    messenger.showSnackBar(
      SnackBar(content: Text("Failed to resolve $handle")),
    );
  });
}
