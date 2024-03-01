import "package:flutter/material.dart";
import "package:kaiteki/constants.dart";
import "package:kaiteki/di.dart";

sealed class SpecialUserAlertReason {
  const SpecialUserAlertReason();

  factory SpecialUserAlertReason.selfReport() => _CannotReportOneself();
  factory SpecialUserAlertReason.staff(String handle) =>
      _CannotReportStaff(handle);
}

class _CannotReportOneself extends SpecialUserAlertReason {}

class _CannotReportStaff extends SpecialUserAlertReason {
  final String handle;

  _CannotReportStaff(this.handle);
}

class ReportSpecialUserAlertDialog extends StatelessWidget {
  final SpecialUserAlertReason reason;

  const ReportSpecialUserAlertDialog({super.key, required this.reason});

  @override
  Widget build(BuildContext context) {
    final reason = this.reason;
    return AlertDialog(
      title: const Text("This user can't be reported"),
      content: ConstrainedBox(
        constraints: kDialogConstraints,
        child: switch (reason) {
          _CannotReportOneself() => const Text(
              "You can't report yourself. Consider deleting your account instead.",
            ),
          _CannotReportStaff() => Text(
              "${reason.handle} is a member of the staff team and therefore can't be reported.",
            ),
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.materialL10n.okButtonLabel),
        ),
      ],
    );
  }
}
