import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/user/user.dart';
import 'package:kaiteki/fediverse/services/users.dart';
import 'package:kaiteki/ui/shared/posts/avatar_widget.dart';
import 'package:kaiteki/utils/extensions.dart';

class UserScreen extends ConsumerStatefulWidget {
  final String id;

  const UserScreen({super.key, required this.id});

  @override
  ConsumerState<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends ConsumerState<UserScreen> {
  Future<User>? _future;

  @override
  void initState() {
    super.initState();
    _future = ref.read(adapterProvider).getUserById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: FutureBuilder<User>(
        future: _future,
        builder: (context, snapshot) {
          final user = snapshot.data;
          return Scaffold(
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    actions: [
                      PopupMenuButton(
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              child: Text("Mute"),
                              value: 1,
                            ),
                            PopupMenuItem(
                              child: Text("Block"),
                              value: 2,
                            ),
                          ];
                        },
                      ),
                    ],
                    title: user?.nullTransform(
                      (d) => ListTile(
                        title: Text(d.displayName!),
                        subtitle: Text(
                          d.handle.toString(),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    pinned: true,
                    forceElevated: innerBoxIsScrolled,
                    expandedHeight: 8.0 * 24.0,
                    flexibleSpace: FlexibleSpaceBar(
                      background: user?.bannerUrl.nullTransform(
                            (u) => Image.network(
                              u,
                              fit: BoxFit.cover,
                              color: Colors.white.withOpacity(0.5),
                              colorBlendMode: BlendMode.modulate,
                            ),
                          ) ??
                          SizedBox(),
                    ),
                  ),
                  if (user != null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text.rich(user.renderDescription(context, ref)),
                            const SizedBox(height: 16.0),
                            if (user.details.fields != null)
                              for (final field
                                  in user.details.fields!.entries) ...[
                                Text(
                                  field.key,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                Text.rich(
                                  user.renderText(
                                    context,
                                    ref,
                                    field.value,
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                              ],
                            IconTheme(
                              data: IconThemeData(
                                color: Theme.of(context).colorScheme.outline,
                                size: 16.0,
                              ),
                              child: DefaultTextStyle.merge(
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  spacing: 16.0,
                                  children: [
                                    if (user.joinDate != null)
                                      _UserDetailItem(
                                        icon: Icon(Icons.today_rounded),
                                        text: Text(
                                          "Joined ${DateFormat('MMMM yyyy').format(user.joinDate!)}",
                                        ),
                                      ),
                                    if (user.details.birthday != null)
                                      _UserDetailItem(
                                        icon: Icon(Icons.cake_rounded),
                                        text: Text(
                                          "Born ${DateFormat('dd MMMM yyyy').format(user.details.birthday!)}",
                                        ),
                                      ),
                                    if (user.details.location != null)
                                      _UserDetailItem(
                                        icon: Icon(Icons.location_on_rounded),
                                        text: Text(user.details.location!),
                                      ),
                                    if (user.details.website != null)
                                      _UserDetailItem(
                                        icon: Icon(Icons.link_rounded),
                                        text: Text(user.details.website!),
                                      ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  CustomSliverPersistentHeader(
                    child: Material(
                      color: Theme.of(context).colorScheme.surface,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TabBar(
                            isScrollable: true,
                            tabs: const [
                              Tab(text: "Posts"),
                              Tab(text: "Media"),
                              Tab(text: "Likes"),
                              Tab(text: "Followers"),
                              Tab(text: "Following"),
                            ],
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: ListView.builder(
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Column(
                      children: [
                        CheckboxListTile(
                          value: false,
                          onChanged: (v) {},
                          title: const Text("Show replies"),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        const Divider(),
                      ],
                    );
                  }

                  index--;
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(index.toString()),
                    ),
                    title: Text("Item $index"),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _UserDetailItem extends StatelessWidget {
  final Widget icon;
  final Widget text;

  const _UserDetailItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(width: 8.0),
        text,
      ],
    );
  }
}

class CustomSliverPersistentHeader extends SingleChildRenderObjectWidget {
  const CustomSliverPersistentHeader({super.key, required super.child});

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderCustomSliverPersistentHeader();
}

class _RenderCustomSliverPersistentHeader
    extends RenderSliverPinnedPersistentHeader {
  @override
  double get maxExtent =>
      child!.getMaxIntrinsicHeight(constraints.crossAxisExtent);

  @override
  double get minExtent =>
      child!.getMaxIntrinsicHeight(constraints.crossAxisExtent);
}
