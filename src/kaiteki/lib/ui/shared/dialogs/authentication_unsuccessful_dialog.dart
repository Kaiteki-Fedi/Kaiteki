import "package:flutter/material.dart";
import "package:kaiteki/common.dart";
import "package:kaiteki/constants.dart";
import "package:kaiteki/exceptions/instance_unreachable_exception.dart";
import "package:kaiteki/utils/extensions.dart";

class AuthenticationUnsuccessfulDialog extends StatelessWidget {
  final TraceableError error;

  const AuthenticationUnsuccessfulDialog({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    Widget icon = const Icon(Icons.error_rounded);
    Widget title = const Text("Login failed");
    Widget description = Text(
      "An error occurred with following message while logging in:\n\n${error.$1}",
    );

    if (error.$1 is InstanceUnreachableException) {
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
          onPressed: () => context.showExceptionDialog(error),
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
