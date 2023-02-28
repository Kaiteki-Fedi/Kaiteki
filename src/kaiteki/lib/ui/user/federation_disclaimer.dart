import "package:flutter/material.dart";

class FederationDisclaimer extends StatelessWidget {
  final VoidCallback? onViewRemote;

  const FederationDisclaimer({super.key, this.onViewRemote});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          const ListTile(
            leading: Icon(Icons.warning_rounded),
            title: Text("This profile might not be up-to-date"),
            subtitle: Text(
              "Your instance might not receive all updates from this account.",
            ),
            dense: true,
          ),
          if (onViewRemote != null)
            Padding(
              padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: onViewRemote,
                  child: const Text("View remote profile"),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
