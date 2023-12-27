import "package:flutter/material.dart";
import "package:kaiteki/account_manager.dart";
import "package:kaiteki/constants.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/posts/avatar_widget.dart";
import "package:kaiteki_core/model.dart";

class MigrationDialog extends ConsumerStatefulWidget {
  const MigrationDialog({super.key});

  @override
  ConsumerState<MigrationDialog> createState() => _MigrationDialogState();
}

class _MigrationDialogState extends ConsumerState<MigrationDialog> {
  bool _hasRead = false;

  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(accountManagerProvider).accounts;

    return AlertDialog(
      title: const Text('Migrate accounts'),
      content: ConstrainedBox(
        constraints: kDialogConstraints,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Select the accounts you want to migrate below and click the Migrate button. Keep the following things in mind:"
              "\n\n"
              "• Your old account will display a migration message pointing to your new account.\n"
              "• Your old followers will be notified of your new account and can automatically follow you there.\n"
              "• Your posts will not be migrated.",
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _AccountPreview(
                    user: accounts.first.user,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(
                    Icons.keyboard_double_arrow_right_rounded,
                    size: 48,
                  ),
                ),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadii.small,
                    onTap: () {},
                    child: _AccountPreview(
                      user: accounts.last.user,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text("I have read and understood the above"),
              value: false,
              onChanged: (value) => setState(() => _hasRead = value ?? false),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(context.l10n.cancelButtonLabel),
        ),
        TextButton(
          onPressed: _hasRead ? () => Navigator.of(context).pop(true) : null,
          child: Text('Migrate'),
        ),
      ],
    );
  }
}

class _AccountPreview extends StatelessWidget {
  final User user;

  const _AccountPreview({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AvatarWidget(user),
        const SizedBox(height: 8),
        Text(
          user.username,
          style: Theme.of(context).textTheme.labelLarge,
          textAlign: TextAlign.center,
        ),
        Text(
          user.host,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
