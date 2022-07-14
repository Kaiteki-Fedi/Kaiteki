import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/user_reference.dart';
import 'package:kaiteki/utils/extensions.dart';

Future<void> resolveAndOpenUser(
  UserReference user,
  BuildContext context,
  WidgetRef ref,
) async {
  final handle = user.toString();
  final l10n = context.getL10n();
  final messenger = ScaffoldMessenger.of(context);
  final lookupSnackbar = messenger.showSnackBar(
    SnackBar(content: Text("Looking up $handle...")),
  );
  final adapter = ref.read(adapterProvider);
  user.resolve(adapter).then((user) async {
    // lookupSnackbar.close();
    if (user == null) throw Exception("User not found");
    await context.showUser(user, ref);
  }).catchError((error, stackTrace) {
    // lookupSnackbar.close();
    messenger.showSnackBar(
      SnackBar(
        content: Text("Failed to resolve $handle"),
        action: SnackBarAction(
          label: l10n.whyButtonLabel,
          onPressed: () => context.showExceptionDialog(error, stackTrace),
        ),
      ),
    );
  });
}
