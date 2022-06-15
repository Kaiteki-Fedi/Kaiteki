import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/instances.dart';
import 'package:kaiteki/ui/auth/discover_instances/instance_card.dart';
import 'package:kaiteki/utils/layout_helper.dart';

class DiscoverInstancesScreen extends StatefulWidget {
  const DiscoverInstancesScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverInstancesScreen> createState() =>
      _DiscoverInstancesScreenState();
}

class _DiscoverInstancesScreenState extends State<DiscoverInstancesScreen> {
  bool _bannerDismissed = false;
  late final Future<List<InstanceData>> _instanceFetch;

  _DiscoverInstancesScreenState() {
    _instanceFetch = fetchInstances();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.getL10n();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.discoverInstancesTitle),
      ),
      body: ResponsiveLayoutBuilder(
        builder: (context, constraints, data) {
          return FutureBuilder<List<InstanceData>>(
            future: _instanceFetch,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final sortedInstances = snapshot.data!.toList(growable: false)
                ..sort((a, b) => a.name.compareTo(b.name));

              return Column(
                children: [
                  if (!_bannerDismissed)
                    MaterialBanner(
                      leading: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        child: Icon(
                          Icons.priority_high_rounded,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                      content: Text(l10n.discoverInstancesDisclaimer),
                      forceActionsBelow: true,
                      actions: [
                        TextButton(
                          onPressed: () =>
                              setState(() => _bannerDismissed = true),
                          child: Text(l10n.okButtonLabel),
                        )
                      ],
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: sortedInstances.length,
                      itemBuilder: (context, index) {
                        final item = sortedInstances[index];
                        return InstanceCard(data: item);
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
