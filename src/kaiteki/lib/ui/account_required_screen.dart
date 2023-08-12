import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/shared/layout/form_widget.dart";

class AccountRequiredScreen extends StatelessWidget {
  const AccountRequiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: FormWidget(
          padding: const EdgeInsets.all(24),
          builder: (context, fillsPage) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.welcome,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(l10n.accountRequiredToContinue),
              Expanded(
                child: Center(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.person_add_rounded),
                    label: Text(l10n.addAccountButtonLabel),
                    style: FilledButton.styleFrom(
                      visualDensity: VisualDensity.comfortable,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 28,
                      ),
                    ),
                    onPressed: () => context.pushNamed("login"),
                  ),
                ),
              ),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () => context.push("/settings"),
                    style: const ButtonStyle(
                      visualDensity: VisualDensity.comfortable,
                    ),
                    child: Text(l10n.settings),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
