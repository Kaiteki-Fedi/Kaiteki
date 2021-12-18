import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/app_colors.dart';
import 'package:kaiteki/fediverse/api/adapters/interfaces/chat_support.dart';
import 'package:kaiteki/fediverse/api/adapters/interfaces/preview_support.dart';
import 'package:kaiteki/fediverse/api/adapters/interfaces/reaction_support.dart';
import 'package:kaiteki/fediverse/api/api_type.dart';
import 'package:kaiteki/fediverse/api/definitions/definitions.dart';
import 'package:kaiteki/utils/extensions/build_context.dart';
import 'package:mdi/mdi.dart';
import 'package:provider/provider.dart';

part 'discover_instances_screen.g.dart';

class DiscoverInstancesScreen extends StatefulWidget {
  const DiscoverInstancesScreen({Key? key}) : super(key: key);

  @override
  _DiscoverInstancesScreenState createState() =>
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.discoverInstancesTitle),
      ),
      body: FutureBuilder(
        future: _instanceFetch,
        builder: (context, AsyncSnapshot<List<InstanceData>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final sortedInstances = snapshot.data!.toList(growable: false);
          sortedInstances.sort((a, b) => a.name.compareTo(b.name));

          return SingleChildScrollView(
            child: Column(
              children: [
                if (!_bannerDismissed)
                  MaterialBanner(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
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
                for (var item in sortedInstances) _InstanceCard(data: item),
              ],
            ),
          );
        },
      ),
    );
  }
}

Future<List<InstanceData>> fetchInstances() async {
  var json = await rootBundle.loadString('assets/instances.json');
  var list = jsonDecode(json) as List<dynamic>;
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
    final apiDefinition = ApiDefinitions.byType(data.type);
    final l10n = AppLocalizations.of(context)!;

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
                          message: l10n.runsOn(apiDefinition.name),
                          child: Image.asset(
                            apiDefinition.theme.iconAssetLocation,
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  child: Row(
                    children: [
                      Text(l10n.chooseButtonLabel),
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Icon(Mdi.arrowRight),
                      ),
                    ],
                  ),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                  ),
                  onPressed: () async {
                    final result =
                        await Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => DiscoverInstanceDetailsScreen(data: data),
                    ));

                    if (result != null) {
                      Navigator.of(context).pop(result);
                    }
                  },
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

class DiscoverInstanceDetailsScreen extends StatelessWidget {
  final InstanceData data;

  const DiscoverInstanceDetailsScreen({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const chipPadding = EdgeInsets.all(8.0);
    final theme = Theme.of(context);

    var i = 1;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
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
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Colors.red.withOpacity(.50),
                          Colors.transparent,
                        ],
                      ).createShader(bounds);
                    },
                    child: FutureBuilder(
                      future: fetchInstanceBackground(context),
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<String?> snapshot,
                      ) {
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

  Future<String?> fetchInstanceBackground(BuildContext context) async {
    final accountManager = Provider.of<AccountManager>(context, listen: false);
    final result = await accountManager.probeInstance(data.name);

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
    final l10n = AppLocalizations.of(context)!;
    final definition = ApiDefinitions.byType(type);
    final name = definition.name;
    final adapter = definition.createAdapter();

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
    final l10n = AppLocalizations.of(context)!;
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
    final l10n = AppLocalizations.of(context)!;
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

  void _onPressed(BuildContext context) async {
    await context.launchUrl(_url);
  }
}

class MastodonCovenantChip extends StatelessWidget {
  static const String _url = "https://joinmastodon.org/covenant";

  const MastodonCovenantChip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ActionChip(
      onPressed: () => _onPressed(context),
      backgroundColor: AppColors.mastodonPrimary,
      label: Text(
        l10n.usesMastodonCovenant,
        style: const TextStyle(color: Colors.white),
      ),
      avatar: const Icon(Mdi.mastodon, size: 20, color: Colors.white),
    );
  }

  void _onPressed(BuildContext context) async {
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
        child: Text(
          number.toString(),
          textScaleFactor: 0.85,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).disabledColor,
        radius: 12.0,
      ),
      title: Text(rule),
      dense: true,
    );
  }
}
