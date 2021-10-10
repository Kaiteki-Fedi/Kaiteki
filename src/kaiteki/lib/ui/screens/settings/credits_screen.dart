import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';
import 'package:url_launcher/url_launcher.dart';

const _items = [
  _CreditsEntry("Craftplacer", "Maintainer", "https://craftplacer.moe/"),
  _CreditsEntry("Odyssey98", "Icon design", "https://mstdn.social/@odyssey98"),
];

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Credits"),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final item = _items[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Text(item.role),
            trailing: item.website != null
                ? IconButton(
                    icon: const Icon(Mdi.openInNew),
                    onPressed: () => launchUrl(
                      messenger,
                      item.website!,
                    ),
                  )
                : null,
          );
        },
        itemCount: _items.length,
      ),
    );
  }

  Future<void> launchUrl(ScaffoldMessengerState scaffold, String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      scaffold.showSnackBar(
        const SnackBar(content: Text("URL couldn't be opened.")),
      );
    }
  }
}

class _CreditsEntry {
  final String name;
  final String role;
  final String? website;

  const _CreditsEntry(this.name, this.role, this.website);
}
