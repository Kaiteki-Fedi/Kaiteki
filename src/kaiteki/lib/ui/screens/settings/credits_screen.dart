import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:mdi/mdi.dart';

const _items = [
  _CreditsEntry("Craftplacer", "Maintainer, Translator (German)",
      "https://craftplacer.moe/"),
  _CreditsEntry("Odyssey98", "Icon design", "https://mstdn.social/@odyssey98"),
  _CreditsEntry(
      "NaiJi", "Translator (Russian)", "https://udongein.xyz/users/NaiJi"),
];

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.creditsTitle)),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final item = _items[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Text(item.role),
            trailing: item.website.nullTransform(
              (website) => IconButton(
                icon: const Icon(Mdi.openInNew),
                onPressed: () => context.launchUrl(item.website!),
              ),
            ),
          );
        },
        itemCount: _items.length,
      ),
    );
  }
}

class _CreditsEntry {
  final String name;
  final String role;
  final String? website;

  const _CreditsEntry(this.name, this.role, this.website);
}
