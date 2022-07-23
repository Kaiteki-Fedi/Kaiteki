import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/ui/shared/form_widget.dart';
import 'package:kaiteki/utils/extensions/m3.dart';

class AccountRequiredScreen extends StatelessWidget {
  const AccountRequiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.getL10n();

    return Scaffold(
      body: SafeArea(
        child: FormWidget(
          padding: const EdgeInsets.all(24),
          builder: (context, fillsPage) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.welcome, textScaleFactor: 3),
              Text(l10n.accountRequiredToContinue),
              Expanded(
                child: Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.person_add_rounded),
                    label: Text(l10n.addAccountButtonLabel),
                    style: Theme.of(context).filledButtonStyle.copyWith(
                          visualDensity: VisualDensity.comfortable,
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 28,
                            ),
                          ),
                        ),
                    onPressed: () => context.push("/login"),
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
