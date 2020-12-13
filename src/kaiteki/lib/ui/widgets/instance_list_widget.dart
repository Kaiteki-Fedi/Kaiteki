import 'package:flutter/material.dart';
import 'package:kaiteki/api/api_type.dart';
import 'package:kaiteki/constants.dart';
import 'package:kaiteki/ui/widgets/separator_text.dart';
import 'package:mdi/mdi.dart';
import 'package:url_launcher/url_launcher.dart';

class InstanceListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 8.0),
      children: [
        ListTile(
          leading: Icon(Mdi.autoFix),
          title: Text("Automatic"),
          subtitle: Text(
            "Kaiteki will try to determine which instance you're trying to add.",
          ),
          isThreeLine: true,
        ),
        Divider(),
        SeparatorText("Select Manually"),
        for (var option in Constants.loginOptions)
          ListTile(
            leading: Image.asset(option.iconAssetPath, height: 24),
            title: Text(option.label),
            onTap: () => Navigator.popAndPushNamed(
              context,
              '/login/${option.apiType.toId()}',
            ),
          ),
        Divider(),
        SeparatorText("More"),
        ListTile(
          leading: Icon(Mdi.dotsHorizontal),
          title: Text("Not in this list"),
          subtitle: Text(
            "Tap here to request support for a different backend.",
          ),
          onTap: () async {
            const String url =
                "https://github.com/Craftplacer/kaiteki/issues/new";

            if (await canLaunch(url))
              await launch(url);
            else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("URL couldn't be opened.")),
              );
            }
          },
        )
      ],
    );
  }
}
