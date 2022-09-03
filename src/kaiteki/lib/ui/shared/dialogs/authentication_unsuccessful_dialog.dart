import 'package:flutter/material.dart';
import 'package:kaiteki/constants.dart';
import 'package:kaiteki/ui/shared/dialogs/exception_dialog.dart';
import 'package:tuple/tuple.dart';

class AuthenticationUnsuccessfulDialog extends StatelessWidget {
  final Tuple2<dynamic, StackTrace?> error;

  const AuthenticationUnsuccessfulDialog({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    // final l10n = context.getL10n();
    return ConstrainedBox(
      constraints: dialogConstraints,
      child: AlertDialog(
        icon: const Icon(Icons.error_rounded),
        title: const Text("Login failed"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "An error occurred with following message while logging in:\n\n${error.item1}",
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: <Widget>[
          TextButton(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => ExceptionDialog(
                exception: error.item1,
                stackTrace: error.item2,
              ),
            ),
            child: const Text("Show details"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).maybePop(),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }
}
