import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/api/api_type.dart';
import 'package:kaiteki/fediverse/api/definitions/definitions.dart';
import 'package:url_launcher/url_launcher.dart';

class ApiTypeDialog extends StatefulWidget {
  @override
  _ApiTypeDialogState createState() => _ApiTypeDialogState();
}

class _ApiTypeDialogState extends State<ApiTypeDialog> {
  ApiDefinition _api = ApiDefinitions.byType(ApiType.mastodon);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Couldn't detect instance type"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
              "Kaiteki tried to find out what software the instance is running but couldn't figure it out. Please select the correct instance backend from down below."),
          DropdownButton<ApiDefinition>(
            isExpanded: true,
            items: ApiDefinitions.definitions.map((def) {
              return DropdownMenuItem<ApiDefinition>(
                value: def,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 8.0,
                      ),
                      child: Image.asset(
                        def.theme.iconAssetLocation,
                        width: 24,
                        height: 24,
                      ),
                    ),
                    Text(def.name),
                  ],
                ),
              );
            }).toList(growable: false),
            onChanged: (ApiDefinition? newValue) {
              setState(() => _api = newValue!);
            },
            value: _api,
          ),
          TextButton(
            child: const Text("Is something missing?"),
            onPressed: () async {
              const String url =
                  "https://github.com/Craftplacer/kaiteki/issues/new";

              if (await canLaunch(url)) {
                Navigator.pop(context);
                await launch(url);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("URL couldn't be opened.")),
                );
              }
            },
          )
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () => Navigator.of(context).pop(_api),
        ),
      ],
    );
  }
}
