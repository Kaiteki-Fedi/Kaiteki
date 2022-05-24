import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/api_type.dart';
import 'package:kaiteki/fediverse/interfaces/chat_support.dart';
import 'package:kaiteki/fediverse/interfaces/preview_support.dart';
import 'package:kaiteki/fediverse/interfaces/reaction_support.dart';
import 'package:kaiteki/utils/extensions/build_context.dart';
import 'package:kaiteki/utils/layout_helper.dart';
import 'package:mdi/mdi.dart';

part 'discover_instances_screen.g.dart';

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
                          Mdi.exclamation,
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
                        return _InstanceCard(data: item);
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

Future<List<InstanceData>> fetchInstances() async {
  final json = await rootBundle.loadString('assets/instances.json');
  final list = jsonDecode(json) as List<dynamic>;
  return list.map((e) {
    return InstanceData.fromJson(e);
  }).toList(growable: false);
}

@JsonSerializable()
class InstanceData {
  final ApiType type;
  final String name;
  final String? shortDescription;
  final String? favicon;
  final List<String>? rules;
  final String? rulesUrl;
  final bool usesCovenant;
  final bool usesMastodonCovenant;

  const InstanceData({
    required this.type,
    required this.name,
    this.shortDescription,
    this.favicon,
    this.rules,
    this.rulesUrl,
    this.usesCovenant = false,
    this.usesMastodonCovenant = false,
  });

  factory InstanceData.fromJson(Map<String, dynamic> json) =>
      _$InstanceDataFromJson(json);

  Map<String, dynamic> toJson() => _$InstanceDataToJson(this);
}

class _InstanceCard extends StatelessWidget {
  final InstanceData data;

  const _InstanceCard({
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

class DiscoverInstanceScreenResult {
  final String instance;
  final bool register;

  DiscoverInstanceScreenResult(this.instance, this.register);
}

class DiscoverInstanceDetailsScreen extends ConsumerWidget {
  final InstanceData data;

  const DiscoverInstanceDetailsScreen({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.getL10n();
    const chipPadding = EdgeInsets.all(8.0);
    final theme = Theme.of(context);

    var i = 1;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 300.0,
              pinned: true,
              floating: true,
              backgroundColor: theme.colorScheme.surface,
              foregroundColor: theme.colorScheme.onSurface,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  data.name,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                collapseMode: CollapseMode.pin,
                background: ColoredBox(
                  color: theme.colorScheme.background,
                  child: ShaderMask(
                    blendMode: BlendMode.dstATop,
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Colors.red.withOpacity(.50),
                          Colors.transparent,
                        ],
                      ).createShader(bounds);
                    },
                    child: FutureBuilder<String?>(
                      future: fetchInstanceBackground(ref),
                      builder: (context, snapshot) {
                        final url = snapshot.data;
                        if (url == null) {
                          return const ColoredBox(color: Colors.grey);
                        } else {
                          return Image.network(url, fit: BoxFit.cover);
                        }
                      },
                    ),
                  ),
                ),
              ),
            )
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (data.shortDescription != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 32.0,
                  ),
                  child: Text(data.shortDescription!),
                ),
              if (data.rules != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(
                      l10n.rules,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            if (data.usesCovenant)
                              const Padding(
                                padding: chipPadding,
                                child: FediverseCovenantChip(),
                              ),
                            if (data.usesMastodonCovenant)
                              const Padding(
                                padding: chipPadding,
                                child: MastodonCovenantChip(),
                              ),
                          ],
                        ),
                      ),
                      for (var rule in data.rules!)
                        RuleListTile(number: i++, rule: rule),
                      if (data.rulesUrl != null)
                        ListTile(
                          title: Text(l10n.rulesLearnMore),
                          trailing: const Icon(Mdi.arrowRight),
                          onTap: () async {
                            await context.launchUrl(data.rulesUrl!);
                          },
                        ),
                    ],
                  ),
                ),
              AdapterFeaturesExpansionTile(data.type),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(
                          DiscoverInstanceScreenResult(data.name, false),
                        );
                      },
                      style: const ButtonStyle(
                        visualDensity: VisualDensity.comfortable,
                      ),
                      child: Text(l10n.loginButtonLabel),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> fetchInstanceBackground(WidgetRef ref) async {
    final accounts = ref.read(accountProvider);
    final result = await accounts.probeInstance(data.name);

    if (result.successful) {
      return result.instance!.backgroundUrl;
    }

    return null;
  }
}

class AdapterFeaturesExpansionTile extends StatelessWidget {
  final ApiType type;

  const AdapterFeaturesExpansionTile(this.type, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.getL10n();
    final name = type.displayName;
    final adapter = type.createAdapter();

    return ExpansionTile(
      title: Text(l10n.aboutBackendTitle(name)),
      children: [
        ListTile(title: Text(l10n.sharedBackendFunctionality(name))),
        _buildFeatureListTile(
          context,
          Mdi.forum,
          l10n.chatSupport,
          adapter is ChatSupport,
        ),
        _buildFeatureListTile(
          context,
          Mdi.emoticon,
          l10n.reactionSupport,
          adapter is ReactionSupport,
        ),
        _buildFeatureListTile(
          context,
          Mdi.commentEditOutline,
          l10n.previewSupport,
          adapter is PreviewSupport,
        ),
      ],
    );
  }

  Widget _buildFeatureListTile(
    BuildContext context,
    IconData icon,
    String feature,
    bool value,
  ) {
    final l10n = context.getL10n();
    final label = value
        ? l10n.featureSupported(feature)
        : l10n.featureUnsupported(feature);

    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: value ? const Icon(Mdi.check) : const Icon(Mdi.close),
    );
  }
}

class FediverseCovenantChip extends StatelessWidget {
  static const String _url =
      "https://github.com/pixeldesu/fediverse-friendly-moderation-covenant/blob/master/README.md";

  const FediverseCovenantChip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.getL10n();
    final colorScheme = Theme.of(context).colorScheme;

    return ActionChip(
      onPressed: () => _onPressed(context),
      backgroundColor: colorScheme.secondary,
      label: Text(
        l10n.usesFediverseCovenant,
        style: TextStyle(color: colorScheme.onSecondary),
      ),
      avatar: Icon(
        Mdi.star,
        size: 20,
        color: colorScheme.onSecondary,
      ),
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    await context.launchUrl(_url);
  }
}

class MastodonCovenantChip extends StatelessWidget {
  static const String _url = "https://joinmastodon.org/covenant";

  const MastodonCovenantChip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.getL10n();

    return ActionChip(
      onPressed: () => _onPressed(context),
      backgroundColor: ApiType.mastodon.theme.primaryColor,
      label: Text(
        l10n.usesMastodonCovenant,
        style: const TextStyle(color: Colors.white),
      ),
      avatar: const Icon(Mdi.mastodon, size: 20, color: Colors.white),
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    await context.launchUrl(_url);
  }
}

class RuleListTile extends StatelessWidget {
  const RuleListTile({
    Key? key,
    required this.number,
    required this.rule,
  }) : super(key: key);

  final int number;
  final String rule;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).disabledColor,
        radius: 12.0,
        child: Text(
          number.toString(),
          textScaleFactor: 0.85,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(rule),
      dense: true,
    );
  }
}
