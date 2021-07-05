import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/api/definitions/definitions.dart';
import 'package:kaiteki/ui/widgets/separator_text.dart';
import 'package:mdi/mdi.dart';
import 'package:url_launcher/url_launcher.dart';

class InstanceListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 8.0),
      children: [
        const ListTile(
          leading: Icon(Mdi.autoFix),
          title: Text("Automatic"),
          subtitle: Text(
            "Kaiteki will try to determine which instance you're trying to add.",
          ),
          isThreeLine: true,
        ),
        const Divider(),
        const SeparatorText("Select Manually"),
        for (var definition in ApiDefinitions.definitions)
          ListTile(
            leading: Image.asset(
              definition.theme.iconAssetLocation,
              height: 24,
            ),
            title: Text(definition.name),
            onTap: () => Navigator.popAndPushNamed(
              context,
              '/login/${definition.id}',
            ),
          ),
        const Divider(),
        const SeparatorText("More"),
        ListTile(
          leading: const Icon(Mdi.dotsHorizontal),
          title: const Text("Not in this list"),
          subtitle: const Text(
            "Tap here to request support for a different backend.",
          ),
          onTap: () async {
            const String url =
                "https://github.com/Craftplacer/kaiteki/issues/new";

            if (await canLaunch(url)) {
              await launch(url);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("URL couldn't be opened.")),
              );
            }
          },
        )
      ],
    );
  }
}
