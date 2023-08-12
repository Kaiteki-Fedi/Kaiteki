import "package:autoscale_tabbarview/autoscale_tabbarview.dart";
import "package:fediverse_objects/mastodon.dart" as mstdn;
import "package:fediverse_objects/misskey.dart" as mk;
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/api_theme.dart";
import "package:kaiteki/fediverse/instance_prober.dart";
import "package:kaiteki/text/parsers/html_text_parser.dart";
import "package:kaiteki/text/text_renderer.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/posts/user_list_dialog.dart";
import "package:kaiteki/ui/shared/timeline/source.dart";
import "package:kaiteki/ui/shared/timeline/timeline.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/social.dart";
import "package:kaiteki_core/utils.dart";
import "package:url_launcher/url_launcher.dart";

class InstanceVettingBottomSheet extends ConsumerStatefulWidget {
  final String instance;

  const InstanceVettingBottomSheet({super.key, required this.instance});

  @override
  ConsumerState<InstanceVettingBottomSheet> createState() =>
      _InstanceVettingBottomSheetState();
}

class _InstanceVettingBottomSheetState
    extends ConsumerState<InstanceVettingBottomSheet> {
  Future<InstanceInformation?>? _future;

  @override
  void initState() {
    super.initState();
    _future = fetchInformation(ref);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          final info = snapshot.data;
          final iconUrl = info?.probe.instance?.iconUrl;
          final name = info?.probe.instance?.name;
          final hasDifferentName =
              name != null && name.toLowerCase() != widget.instance;

          final instance = info?.probe.instance;

          const leadingFallback = Icon(Icons.public_rounded);
          Widget leading = leadingFallback;

          if (iconUrl != null) {
            leading = Image.network(
              iconUrl.toString(),
              width: 24,
              height: 24,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => leadingFallback,
            );
          }

          return ProviderScope(
            overrides: [
              if (info == null)
                adapterProvider.overrideWith(
                  (_) => throw StateError(
                    "Provider is not supposed to be accessed from this widget tree yet",
                  ),
                )
              else
                adapterProvider.overrideWith((_) => info.adapter),
            ],
            child: CustomScrollView(
              primary: true,
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildThumbnail(context, snapshot, instance),
                      ListTile(
                        leading: leading,
                        title: Text(
                          name ?? widget.instance,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle:
                            hasDifferentName ? Text(widget.instance) : null,
                        trailing: MediaQuery.of(context).size.width >= 600
                            ? FilledButton.tonalIcon(
                                onPressed: () async {
                                  await launchUrl(
                                    Uri.https(widget.instance),
                                    mode: LaunchMode.externalApplication,
                                  );
                                },
                                icon: const Icon(Icons.open_in_browser_rounded),
                                label: const Text("Visit"),
                                style: FilledButton.styleFrom(
                                  visualDensity: VisualDensity.comfortable,
                                ),
                              )
                            : IconButton.filledTonal(
                                icon: const Icon(Icons.open_in_browser_rounded),
                                splashRadius: 24,
                                onPressed: () async {
                                  await launchUrl(
                                    Uri.https(widget.instance),
                                    mode: LaunchMode.externalApplication,
                                  );
                                },
                              ),
                      ),
                      if (info != null) ..._buildInstanceInfo(info),
                      if (snapshot.hasError)
                        ListTile(
                          leading: const Icon(Icons.error_rounded),
                          title: const Text(
                            "Couldn't fetch instance information",
                          ),
                          trailing: FilledButton.tonal(
                            onPressed: () {
                              context.showExceptionDialog(
                                snapshot.traceableError!,
                              );
                            },
                            child: const Text("Show details"),
                          ),
                        ),
                    ],
                  ),
                ),
                if (info != null)
                  const TimelineSliver(
                    StandardTimelineSource(TimelineType.local),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildThumbnail(
    BuildContext context,
    AsyncSnapshot<InstanceInformation?> snapshot,
    Instance<dynamic>? instance,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: ColoredBox(
            color: Theme.of(context).colorScheme.surface,
            child: snapshot.connectionState == ConnectionState.waiting
                ? centeredCircularProgressIndicator
                : instance?.backgroundUrl.nullTransform(
                    (bgUrl) => Image.network(
                      bgUrl.toString(),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox(),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildInstanceInfo(InstanceInformation info) {
    final type = info.probe.type;

    final instance = info.probe.instance;
    final description = instance?.description?.trim();
    final hasDescription = description != null && description.isNotEmpty;

    final postCount = instance?.postCount;
    final userCount = instance?.userCount;
    final numberFormat = NumberFormat.compact();
    final stats = <Widget>[
      if (postCount != null)
        Expanded(
          child: Column(
            children: [
              Text(
                numberFormat.format(postCount).toLowerCase(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text("Posts"),
            ],
          ),
        ),
      if (userCount != null)
        Expanded(
          child: Column(
            children: [
              Text(
                numberFormat.format(userCount).toLowerCase(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text("Users"),
            ],
          ),
        ),
    ].joinWithValue(
      const SizedBox(
        height: 32,
        child: VerticalDivider(width: 1),
      ),
    );

    final mastodon = (instance?.source as Object?).safeCast<mstdn.Instance>();
    final misskey = (instance?.source as Object?).safeCast<mk.Meta>();

    final email = mastodon?.contact.email ?? misskey?.maintainerEmail;
    final version = mastodon?.version ?? misskey?.version;

    Future<void> contactStaff() {
      return launchUrl(
        Uri.parse("mailto:$email"),
        mode: LaunchMode.externalApplication,
      );
    }

    final rules = instance?.rules ?? [];
    return [
      const TabBar(
        tabs: [
          Tab(text: "Description"),
          Tab(text: "Rules"),
          Tab(text: "Staff"),
          Tab(text: "Software"),
        ],
      ),
      const Divider(),
      AutoScaleTabBarView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: hasDescription
                  ? Text.rich(
                      TextRenderer.fromContext(context, ref).render(
                        parseText(description, const {HtmlTextParser()}),
                      ),
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  : Text(
                      "No description provided",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (instance?.tosUrl != null)
                ListTile(
                  title: Text(
                    "Read the terms of service online",
                    style: Theme.of(context).colorScheme.primary.textStyle,
                  ),
                  onTap: () async {
                    await launchUrl(
                      instance!.tosUrl!,
                      mode: LaunchMode.externalApplication,
                    );
                  },
                )
              else if (rules.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "No rules provided",
                    style: Theme.of(context).colorScheme.outline.textStyle,
                  ),
                ),
              for (int i = 0; i < rules.length; i++)
                ListTile(
                  leading: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox.square(
                      dimension: 24,
                      child: Center(
                        child: Text(
                          (i + 1).toString(),
                          style: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant
                              .textStyle,
                        ),
                      ),
                    ),
                  ),
                  title: Text(rules[i]),
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  titleAlignment: ListTileTitleAlignment.top,
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: FilledButton.tonalIcon(
                  icon: const Icon(Icons.email_rounded),
                  onPressed: email == null ? null : contactStaff,
                  label: const Text("Send email to staff"),
                  style: FilledButton.styleFrom(
                    visualDensity: VisualDensity.comfortable,
                  ),
                ),
              ),
              if (instance?.administrators?.isNotEmpty == true) ...[
                ListTile(
                  title: Text(
                    "Administrators",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                for (final admin in instance!.administrators!)
                  UserListTile(user: admin),
                const Divider(),
              ],
              if (instance?.moderators?.isNotEmpty == true) ...[
                ListTile(
                  title: Text(
                    "Moderators",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                for (final mod in instance!.moderators!)
                  UserListTile(user: mod),
                const Divider(),
              ],
            ],
          ),
          Column(
            children: [
              if (type != null)
                ListTile(
                  leading: Image.asset(
                    type.theme.iconAssetLocation!,
                    width: 24,
                    height: 24,
                  ),
                  title: Text(type.displayName),
                  subtitle: version == null ? null : Text(version),
                ),
            ],
          ),
        ],
      ),
      const Divider(),
      if (stats.isNotEmpty) ...[
        const SizedBox(height: 8),
        Row(children: stats),
        const SizedBox(height: 8),
        const Divider(),
      ],
    ];
  }

  Future<InstanceInformation?> fetchInformation(WidgetRef ref) async {
    final probe = await ref.read(probeInstanceProvider(widget.instance).future);
    if (probe.type == null) return null;

    final adapter = await probe.type!.createAdapter(widget.instance);

    return InstanceInformation(probe, adapter);
  }
}

class InstanceInformation {
  final InstanceProbeResult probe;
  final BackendAdapter adapter;

  InstanceInformation(this.probe, this.adapter);
}
