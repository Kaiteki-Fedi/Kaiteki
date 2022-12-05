import 'package:flutter/material.dart';
import 'package:kaiteki/constants.dart';
import 'package:kaiteki/exceptions/instance_unreachable_exception.dart';
import 'package:kaiteki/ui/shared/dialogs/exception_dialog.dart';
import 'package:tuple/tuple.dart';

class AuthenticationUnsuccessfulDialog extends StatelessWidget {
  final Tuple2<dynamic, StackTrace?> error;

  const AuthenticationUnsuccessfulDialog({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    Widget icon = const Icon(Icons.error_rounded);
    Widget title = const Text("Login failed");
    Widget description = Text(
      "An error occurred with following message while logging in:\n\n${error.item1}",
    );

    if (error.item1 is InstanceUnreachableException) {
      icon = const Icon(Icons.public_off_rounded);
      title = const Text("Instance unreachable");
      description = const Text(
        "The instance you are trying to reach is unreachable. Are you sure the instance exists?",
      );
    }

    // final l10n = context.getL10n();
    return AlertDialog(
      icon: icon,
      title: title,
      content: SizedBox(
        width: dialogConstraints.minWidth,
        child: description,
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
    );
  }
}
