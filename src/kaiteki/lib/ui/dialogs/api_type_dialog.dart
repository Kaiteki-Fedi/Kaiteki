import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/api_type.dart';
import 'package:kaiteki/utils/extensions/build_context.dart';

class ApiTypeDialog extends StatefulWidget {
  const ApiTypeDialog({Key? key}) : super(key: key);

  @override
  State<ApiTypeDialog> createState() => _ApiTypeDialogState();
}

class _ApiTypeDialogState extends State<ApiTypeDialog> {
  ApiType _api = ApiType.mastodon;

  @override
  Widget build(BuildContext context) {
    final l10n = context.getL10n();
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
          DropdownButton<ApiType>(
            isExpanded: true,
            items: ApiType.values.map((def) {
              final iconLocation = def.theme.iconAssetLocation;
              return DropdownMenuItem<ApiType>(
                value: def,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 8.0,
                      ),
                      child: iconLocation == null
                          ? Image.asset(
                              iconLocation!,
                              width: 24,
                              height: 24,
                            )
                          : const SizedBox(),
                    ),
                    Text(def.name),
                  ],
                ),
              );
            }).toList(growable: false),
            onChanged: (newValue) => setState(() => _api = newValue!),
            value: _api,
          ),
          TextButton(
            child: Text(l10n.apiTypeDialog_missing),
            onPressed: () async {
              const issuesUrl =
                  "https://github.com/Craftplacer/kaiteki/issues/new";
              if (await context.launchUrl(issuesUrl)) {
                Navigator.pop(context);
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
