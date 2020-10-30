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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome to Kaiteki!", textScaleFactor: 3),
            Text("To continue, you need to log into at least one instance."),
            Expanded(
              child: Center(
                child: ElevatedButton.icon(
                  icon: Icon(Mdi.accountPlus),
                  label: Text("Add account"),
                  style: ButtonStyle(
                    visualDensity: VisualDensity.comfortable,
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 28)),
                  ),
                  onPressed: () =>
                      Navigator.of(context).pushNamed("/accounts/add"),
                ),
              ),
            ),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pushNamed("/settings"),
                  child: Text("Settings"),
                  style: ButtonStyle(visualDensity: VisualDensity.comfortable),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
