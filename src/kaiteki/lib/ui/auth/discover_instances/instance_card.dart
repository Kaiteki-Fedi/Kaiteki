import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/instances.dart';
import 'package:kaiteki/ui/auth/discover_instances/discover_instance_details_screen.dart';
import 'package:mdi/mdi.dart';

class InstanceCard extends StatelessWidget {
  final InstanceData data;

  const InstanceCard({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.getL10n();
    final iconLocation = data.type.theme.iconAssetLocation;

    return Card(
      margin: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: data.favicon == null
                ? const Icon(Icons.public)
                : Image.network(
                    data.favicon!,
                    width: 24,
                    height: 24,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.public);
                    },
                  ),
            title: Text(data.name),
            subtitle: data.shortDescription == null
                ? null
                : Text(data.shortDescription!),
          ),
          const Divider(height: 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Wrap(
                      spacing: 6,
                      children: [
                        Tooltip(
                          message: l10n.runsOn(data.type.displayName),
                          child: iconLocation == null
                              ? const Icon(Mdi.earth)
                              : Image.asset(
                                  iconLocation,
                                  width: 24,
                                  height: 24,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                  ),
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) {
                          return DiscoverInstanceDetailsScreen(data: data);
                        },
                      ),
                    );

                    if (result != null) {
                      navigator.pop(result);
                    }
                  },
                  child: Row(
                    children: [
                      Text(l10n.chooseButtonLabel),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(Mdi.arrowRight),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
