import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kaiteki/fediverse/api/api_type.dart';
import 'package:kaiteki/fediverse/api/definitions/definitions.dart';
import 'package:url_launcher/url_launcher.dart';

class ApiTypeDialog extends StatefulWidget {
  const ApiTypeDialog({Key? key}) : super(key: key);

  @override
  _ApiTypeDialogState createState() => _ApiTypeDialogState();
}

class _ApiTypeDialogState extends State<ApiTypeDialog> {
  ApiDefinition _api = ApiDefinitions.byType(ApiType.mastodon);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final materialL10n = Localizations.of<MaterialLocalizations>(
      context,
      MaterialLocalizations,
    )!;

    return AlertDialog(
      title: Text(l10n.apiTypeDialog_title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.apiTypeDialog_description),
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
            child: Text(l10n.apiTypeDialog_missing),
            onPressed: () async {
              const String url =
                  "https://github.com/Craftplacer/kaiteki/issues/new";

              if (await canLaunch(url)) {
                Navigator.pop(context);
                await launch(url);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.failedToLaunchUrl)),
                );
              }
            },
          )
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text(materialL10n.cancelButtonLabel),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text(materialL10n.okButtonLabel),
          onPressed: () => Navigator.of(context).pop(_api),
        ),
      ],
    );
  }
}
