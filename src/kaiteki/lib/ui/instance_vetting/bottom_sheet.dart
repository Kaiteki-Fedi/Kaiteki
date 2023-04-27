import "package:fediverse_objects/mastodon.dart" as mstdn;
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/adapter.dart";
import "package:kaiteki/fediverse/instance_prober.dart";
import "package:kaiteki/fediverse/model/timeline_kind.dart";
import "package:kaiteki/ui/shared/posts/user_list_dialog.dart";
import "package:kaiteki/ui/shared/timeline.dart";
import "package:kaiteki/utils/extensions.dart";
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
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        final info = snapshot.data;
        final type = info?.probe.type;
        final iconUrl = info?.probe.instance?.iconUrl;
        final name = info?.probe.instance?.name;
        final hasDifferentName =
            name != null && name.toLowerCase() != widget.instance;

        final instance = info?.probe.instance;
        final description = instance?.description?.trim();
        final hasDescription = description != null && description.isNotEmpty;

        final postCount = instance?.postCount;
        final userCount = instance?.userCount;

        final email = (instance?.source as Object?)
            .safeCast<mstdn.Instance>()
            ?.contact
            .email;
        final version =
            (instance?.source as Object?).safeCast<mstdn.Instance>()?.version;

        Widget leading;

        if (info == null && !snapshot.hasError) {
          leading = const SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(),
          );
        } else if (iconUrl != null) {
          leading = Image.network(
            iconUrl.toString(),
            width: 24,
            height: 24,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(Icons.public_rounded),
          );
        } else {
          leading = const Icon(Icons.public_rounded);
        }

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
          child: NestedScrollView(
            headerSliverBuilder: (context, _) => [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      leading: leading,
                      title: Text(
                        name ?? widget.instance,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      subtitle: hasDifferentName ? Text(widget.instance) : null,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (email != null) ...[
                            IconButton.filledTonal(
                              icon: const Icon(Icons.email_rounded),
                              splashRadius: 24,
                              onPressed: () async {
                                await launchUrl(
                                  Uri.parse("mailto:$email"),
                                  mode: LaunchMode.externalApplication,
                                );
                              },
                              tooltip: "Send email to staff",
                            ),
                            const SizedBox(width: 8),
                          ],
                          IconButton.filledTonal(
                            icon: const Icon(Icons.open_in_browser_rounded),
                            splashRadius: 24,
                            onPressed: () async {
                              await launchUrl(
                                Uri.https(widget.instance),
                                mode: LaunchMode.externalApplication,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    if (hasDescription)
                      ListTile(
                        title: Text(
                          description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        leading: const SizedBox(),
                      ),
                    const Divider(),
                    if (type != null) ...[
                      ListTile(
                        title: Text(
                          "Instance Software",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      ListTile(
                        leading: Image.asset(type.theme.iconAssetLocation!),
                        title: Text(type.displayName),
                        subtitle: version == null ? null : Text(version),
                      ),
                      const Divider(),
                    ],
                    if (instance?.administrator != null) ...[
                      ListTile(
                        title: Text(
                          "Administrator",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      UserListTile(user: instance!.administrator!),
                      const Divider(),
                    ],
                    if (stats.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(children: stats),
                      const SizedBox(height: 8),
                      const Divider(),
                    ],
                  ],
                ),
              ),
            ],
            body: CustomScrollView(
              slivers: <Widget>[
                if (info != null)
                  const TimelineSliver.kind(
                    kind: TimelineKind.local,
                  ),
              ],
            ),
          ),
        );
      },
    );
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
