import "package:flutter/material.dart";
import "package:kaiteki/constants.dart" as consts;
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/api_theme.dart";
import "package:kaiteki/link_constants.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki_core_backends/kaiteki_core_backends.dart";
import "package:url_launcher/url_launcher_string.dart";

class ApiTypeDialog extends StatefulWidget {
  const ApiTypeDialog({super.key});

  @override
  State<ApiTypeDialog> createState() => _ApiTypeDialogState();
}

class _ApiTypeDialogState extends State<ApiTypeDialog> {
  BackendType _api = BackendType.mastodon;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ConstrainedBox(
      constraints: consts.kDialogConstraints,
      child: AlertDialog(
        icon: const Icon(Icons.help_rounded),
        title: Text(l10n.apiTypeDialog_title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.apiTypeDialog_description),
            const SizedBox(height: 16),
            ApiTypeDropDownButton(
              type: _api,
              onChanged: (newValue) => setState(() => _api = newValue!),
            ),
            TextButton(
              child: Text(l10n.apiTypeDialog_missing),
              onPressed: () async {
                final navigator = Navigator.of(context);
                await launchUrlString(requestBackendUrl).then(navigator.pop);
              },
            ),
          ],
        ),
        actions: <Widget>[
          const CancelTextButton(),
          TextButton(
            child: Text(l10n.okButtonLabel),
            onPressed: () => Navigator.of(context).pop(_api),
          ),
        ],
      ),
    );
  }
}

class ApiTypeDropDownButton extends StatelessWidget {
  final BackendType type;
  final void Function(BackendType? type)? onChanged;

  const ApiTypeDropDownButton({
    super.key,
    required this.type,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<BackendType>(
          isExpanded: true,
          items: BackendType.values.map((type) {
            return DropdownMenuItem<BackendType>(
              value: type,
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: _buildIcon(type),
                    ),
                    Text(type.name),
                  ],
                ),
              ),
            );
          }).toList(growable: false),
          onChanged: onChanged,
          value: type,
        ),
      ),
    );
  }

  Widget _buildIcon(BackendType type) {
    final iconLocation = type.theme.iconAssetLocation;

    if (iconLocation != null) {
      return Image.asset(
        iconLocation,
        width: 24,
        height: 24,
      );
    }

    return const SizedBox();
  }
}
