import 'package:breakpoint/breakpoint.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/instances.dart';
import 'package:kaiteki/ui/auth/discover_instances/instance_card.dart';
import 'package:kaiteki/ui/shared/layout/breakpoint_container.dart';

class DiscoverInstancesScreen extends StatefulWidget {
  const DiscoverInstancesScreen({super.key});

  @override
  State<DiscoverInstancesScreen> createState() =>
      _DiscoverInstancesScreenState();
}

class _DiscoverInstancesScreenState extends State<DiscoverInstancesScreen> {
  late final Future<List<InstanceData>> _instanceFetch;
  late ScaffoldFeatureController<MaterialBanner, MaterialBannerClosedReason>
      _banner;

  _DiscoverInstancesScreenState() {
    _instanceFetch = fetchInstances();
  }

  @override
  void initState() {
    // run code after BuildContext is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _banner = ScaffoldMessenger.of(context).showMaterialBanner(
        _buildBanner(context),
      );
    });

    super.initState();
  }

  @override
  void dispose() {
    _banner.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.getL10n();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.discoverInstancesTitle)),
      body: BreakpointBuilder(
        builder: (context, breakpoint) {
          return BreakpointContainer(
            breakpoint: breakpoint,
            child: FutureBuilder<List<InstanceData>>(
              future: _instanceFetch,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final sortedInstances = snapshot.data!.toList(growable: false)
                  ..sort((a, b) => a.name.compareTo(b.name));

                return Column(
                  children: [
                    // if (!_bannerDismissed) _buildBanner(context),
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
            ),
          );
        },
      ),
    );
  }

  MaterialBanner _buildBanner(BuildContext context) {
    final l10n = context.getL10n();
    return MaterialBanner(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Icon(
          Icons.priority_high_rounded,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      content: Text(l10n.discoverInstancesDisclaimer),
      padding: const EdgeInsetsDirectional.only(
        start: 16.0,
        top: 2.0,
        bottom: 8,
      ),

      /// forceActionsBelow: true,
      actions: [
        TextButton(
          onPressed: () => _banner.close(),
          child: Text(l10n.okButtonLabel),
        )
      ],
    );
  }
}
