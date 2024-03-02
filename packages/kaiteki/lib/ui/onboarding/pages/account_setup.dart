import "package:flutter/material.dart" hide BackButton;
import "package:go_router/go_router.dart";
import "package:kaiteki/account_manager.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/onboarding/widgets/back_button.dart";

class AccountSetupPage extends ConsumerWidget {
  const AccountSetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasAccounts =
        ref.watch(accountManagerProvider.select((e) => e.accounts.isNotEmpty));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              "Sign in to your account",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              "To use Kaiteki, you need to sign in to at least one account.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 16.0,
              ),
              child: Column(
                children: [
                  Card.outlined(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => context.pushNamed("login"),
                      child: Center(
                        child: ListTile(
                          leading: Image.asset("assets/icons/fediverse.png"),
                          title: const Text("Fediverse"),
                          subtitle:
                              const Text("Mastodon, Pleroma, Misskey, etc."),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card.outlined(
                    child: ListTile(
                      leading: switch (Theme.of(context).brightness) {
                        Brightness.light =>
                          Image.asset("assets/icons/tumblr_blue.png"),
                        Brightness.dark =>
                          Image.asset("assets/icons/tumblr_white.png"),
                      },
                      onTap: () => context.pushNamed(
                        "login",
                        queryParameters: {"instance": "tumblr.com"},
                      ),
                      title: const Text("Tumblr"),
                      subtitle: const Text("Experimental"),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card.outlined(
                    child: ListTile(
                      leading: Image.asset("assets/icons/bluesky.png"),
                      title: const Text("Bluesky"),
                      subtitle: const Text("Coming soon™"),
                      enabled: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Row(
              children: [
                const BackButton(),
                const Spacer(),
                if (hasAccounts)
                  FilledButton.icon(
                    icon: const Icon(Icons.chevron_right_rounded),
                    iconAlignment: IconAlignment.end,
                    label: Text(context.l10n.nextButtonLabel),
                    onPressed: () => context.push("/onboarding/preferences"),
                    style: FilledButton.styleFrom(
                      visualDensity: VisualDensity.standard,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
