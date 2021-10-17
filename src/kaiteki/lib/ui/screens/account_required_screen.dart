import 'package:flutter/material.dart';
import 'package:kaiteki/ui/widgets/layout/form_widget.dart';
import 'package:mdi/mdi.dart';

class AccountRequiredScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FormWidget(
          padding: const EdgeInsets.all(24),
          builder: (context, fillsPage) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome to Kaiteki!",
                textScaleFactor: 3,
              ),
              const Text(
                "To continue, you need to log into at least one instance.",
              ),
              Expanded(
                child: Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Mdi.accountPlus),
                    label: const Text("Add account"),
                    style: ButtonStyle(
                      visualDensity: VisualDensity.comfortable,
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 28,
                        ),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pushNamed("/login"),
                  ),
                ),
              ),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("/settings");
                    },
                    child: const Text("Settings"),
                    style: const ButtonStyle(
                      visualDensity: VisualDensity.comfortable,
                    ),
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
