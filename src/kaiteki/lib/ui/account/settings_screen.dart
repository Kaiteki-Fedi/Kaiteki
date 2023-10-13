import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/account_manager.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/settings/section_header.dart";
import "package:kaiteki/ui/settings/settings_container.dart";
import "package:kaiteki/ui/settings/settings_section.dart";
import "package:kaiteki/ui/shared/dialogs/account_deletion/dialog.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/kaiteki_core.dart";

class AccountSettingsScreen extends ConsumerStatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  ConsumerState<AccountSettingsScreen> createState() =>
      _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends ConsumerState<AccountSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account settings"),
        actions: const [
          // IconButton(
          //   onPressed: null,
          //   icon: Icon(Icons.help_rounded),
          //   tooltip: "Help",
          // ),
        ],
      ),
      body: SingleChildScrollView(
        child: SettingsContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SettingsSection(
                title: const SectionHeader("Safety"),
                children: [
                  ListTile(
                    leading: const Icon(Icons.volume_off),
                    title: const Text("Mutes"),
                    onTap: () => context.pushNamed(
                      "accountMutes",
                      pathParameters: ref.accountRouterParams,
                    ),
                  ),
                  const ListTile(
                    leading: Icon(Icons.do_disturb_on_rounded),
                    title: Text("Blocks"),
                    enabled: false,
                  ),
                ],
              ),
              const SettingsSection(
                title: SectionHeader("Privacy"),
                children: [
                  SwitchListTile.adaptive(
                    secondary: Icon(Icons.person_add_disabled_rounded),
                    title: Text("Approve followers manually"),
                    onChanged: null,
                    value: false,
                  ),
                  ListTile(
                    leading: Icon(Icons.person_off),
                    title: Text("Hide following users"),
                    enabled: false,
                  ),
                  SwitchListTile.adaptive(
                    secondary: Icon(Icons.search_off_rounded),
                    title: Text("Prevent search engine crawling"),
                    onChanged: null,
                    value: false,
                  ),
                ],
              ),
              const SettingsSection(
                title: SectionHeader("Security"),
                children: [
                  ListTile(
                    leading: Icon(Icons.email_rounded),
                    title: Text("Change email address"),
                    enabled: false,
                  ),
                  ListTile(
                    leading: Icon(Icons.lock_outline_rounded),
                    title: Text("Change password"),
                    enabled: false,
                  ),
                  ListTile(
                    leading: Icon(Icons.devices_rounded),
                    title: Text("Manage sessions"),
                    enabled: false,
                  ),
                  ListTile(
                    leading: Icon(Icons.password_rounded),
                    title: Text("Two-factor authentication"),
                    enabled: false,
                  ),
                ],
              ),
              SettingsSection(
                title: const SectionHeader("Account management"),
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.close_rounded,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    title: const Text("Delete Account"),
                    onTap: ref.watch(currentAccountProvider)?.adapter
                            is AccountDeletionSupport
                        ? () => _onDelete(ref)
                        : null,
                  ),
                  const ListTile(
                    leading: Icon(
                      Icons.arrow_forward_rounded,
                      // color: Theme.of(context).colorScheme.secondary,
                    ),
                    title: Text("Move Account"),
                    enabled: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onDelete(WidgetRef ref) async {
    final account = ref.read(currentAccountProvider);
    if (account == null) return;
    await showDialog(
      context: context,
      builder: (_) => AccountDeletionDialog(
        account: account,
        onDelete: (password) async {
          final deletionInterface = account.adapter as AccountDeletionSupport;
          await deletionInterface.deleteAccount(password);
          await ref.read(accountManagerProvider.notifier).remove(account);

          if (mounted) Navigator.of(context).pop();
        },
      ),
    );
  }
}
