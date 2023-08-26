import "package:animations/animations.dart";
import "package:flutter/material.dart";
import "package:kaiteki/constants.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/model/auth/account.dart";
import "package:kaiteki/ui/shared/dialogs/account_deletion/authentication_page.dart";
import "package:kaiteki/ui/shared/dialogs/account_deletion/confirmation_page.dart";
import "package:kaiteki/ui/shared/dialogs/account_deletion/in_progress_page.dart";
import "package:kaiteki/utils/extensions.dart";

class AccountDeletionDialog extends StatefulWidget {
  final Future<void> Function(String password) onDelete;

  /// The account to be deleted.
  ///
  /// This field is only used to display the account name in the dialog.
  final Account account;

  const AccountDeletionDialog({
    super.key,
    required this.onDelete,
    required this.account,
  });

  @override
  State<AccountDeletionDialog> createState() => _AccountDeletionDialogState();
}

class _AccountDeletionDialogState extends State<AccountDeletionDialog> {
  final _authPageKey = GlobalKey<AccountDeletionAuthenticationPageState>();
  Future<void>? _deleteFuture;
  var _page = _AccountDeletionDialogStatePage.confirmation;
  bool confirmed = false;

  @override
  Widget build(BuildContext context) {
    final isDeleting = _page == _AccountDeletionDialogStatePage.deletion;

    return WillPopScope(
      onWillPop: () async => _deleteFuture == null,
      child: ConstrainedBox(
        constraints: dialogConstraints,
        child: AlertDialog(
          icon: isDeleting ? null : const Icon(Icons.delete_forever_rounded),
          title: isDeleting ? null : const Text("Delete account?"),
          content: SizedBox(
            width: 320,
            child: PageTransitionSwitcher(
              transitionBuilder: (c, a, s) => SharedAxisTransition(
                animation: a,
                secondaryAnimation: s,
                transitionType: SharedAxisTransitionType.horizontal,
                fillColor: Colors.transparent,
                child: c,
              ),
              child: _buildPage(),
            ),
          ),
          actions: isDeleting ? null : _buildActions(),
        ),
      ),
    );
  }

  List<Widget> _buildActions() {
    return [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text(context.materialL10n.cancelButtonLabel),
      ),
      TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.error,
        ),
        onPressed: _onNext,
        child: confirmed
            ? Text(context.l10n.deleteButtonLabel)
            : Text(context.materialL10n.continueButtonLabel),
      ),
    ];
  }

  Widget _buildPage() {
    switch (_page) {
      case _AccountDeletionDialogStatePage.confirmation:
        return AccountDeletionConfirmationPage(account: widget.account);
      case _AccountDeletionDialogStatePage.authentication:
        return AccountDeletionAuthenticationPage(key: _authPageKey);
      case _AccountDeletionDialogStatePage.deletion:
        return const AccountDeletionInProgressPage();
    }
  }

  void _onNext() {
    if (_page == _AccountDeletionDialogStatePage.confirmation) {
      setState(() => _page = _AccountDeletionDialogStatePage.authentication);
      return;
    }

    if (_page == _AccountDeletionDialogStatePage.authentication) {
      final password = _authPageKey.currentState?.password;

      if (password == null) return;

      _deleteFuture = widget.onDelete(password).then((_) {
        Navigator.of(context).pop();
        _deleteFuture = null;
      }).catchError((error, stackTrace) {
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            icon: const Icon(Icons.error_rounded),
            title: const Text("Account deletion failed"),
            content:
                const Text("An error occurred while deleting your account."),
            actions: [
              TextButton(
                onPressed: () =>
                    context.showExceptionDialog((error, stackTrace)),
                child: Text(context.l10n.showDetailsButtonLabel),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).maybePop(),
                child: Text(context.materialL10n.okButtonLabel),
              ),
            ],
          ),
        );
      });

      setState(() => _page = _AccountDeletionDialogStatePage.deletion);
      return;
    }
  }
}

enum _AccountDeletionDialogStatePage {
  confirmation,
  authentication,
  deletion,
}
