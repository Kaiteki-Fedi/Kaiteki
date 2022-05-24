import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kaiteki/account_manager.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/ui/widgets/icon_landing_widget.dart';
import 'package:kaiteki/ui/widgets/post_widget.dart';
import 'package:kaiteki/ui/widgets/posts/avatar_widget.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:kaiteki/utils/layout_helper.dart';
import 'package:kaiteki/utils/text/text_renderer_theme.dart';
import 'package:mdi/mdi.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:url_launcher/url_launcher.dart';

const _columnPadding = 12.0;
const _gutter = 16.0;

class UserScreen extends ConsumerStatefulWidget {
  final String id;
  final User? initialUser;

  const UserScreen.fromId(
    this.id, {
    Key? key,
  })  : initialUser = null,
        super(key: key);

  UserScreen.fromUser(
    User this.initialUser, {
    Key? key,
  })  : id = initialUser.id,
        super(key: key);

  @override
  ConsumerState<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends ConsumerState<UserScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late Future<User> _future;
  late Future<PaletteGenerator?> _bannerFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final accounts = ref.watch(accountProvider);
    _future = accounts.adapter.getUserById(widget.id);
    _bannerFuture = _future.then((user) async {
      final banner = user.bannerUrl;
      if (banner == null) {
        return null;
      } else {
        final image = NetworkImage(banner);
        return PaletteGenerator.fromImageProvider(image);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      initialData: widget.initialUser,
      future: _future,
      builder: (_, snapshot) {
        return LayoutBuilder(
          builder: (context, constraints) {
            switch (getScreenSize(constraints.maxWidth)) {
              case ScreenSize.xs:
              case ScreenSize.s:
                return _buildMobile(snapshot, constraints);
              case ScreenSize.m:
              case ScreenSize.l:
                return _buildDesktop(context, snapshot, constraints);
            }
          },
        );
      },
    );
  }

  Widget _buildDesktop(
    BuildContext context,
    AsyncSnapshot<User> snapshot,
    BoxConstraints constraints,
  ) {
    final user = snapshot.data;

    return FutureBuilder<PaletteGenerator?>(
      future: _bannerFuture,
      builder: (context, snapshot) {
        final brightness = snapshot.data != null //
            ? ThemeData.estimateBrightnessForColor(
                snapshot.data!.paletteColors.first.color,
              )
            : null;

        return NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                actions: buildActions(context, user: user),
                expandedHeight: user?.bannerUrl != null ? 450.0 : null,
                pinned: true,
                forceElevated: true,
                flexibleSpace: DesktopAccountHeader(
                  tabController: _tabController,
                  tabs: buildTabs(context, user, true, Axis.horizontal),
                  constraints: constraints,
                  user: user,
                ),
                foregroundColor: brightness?.inverted.getColor(),
                systemOverlayStyle: brightness?.inverted.systemUiOverlayStyle,
              ),
            ];
          },
          body: Material(
            child: ResponsiveLayoutBuilder(
              builder: (context, constraints, data) {
                return Row(
                  children: [
                    Flexible(
                      child: Column(
                        children: [
                          if (user != null)
                            Expanded(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(_columnPadding),
                                  child: UserInfoWidget(user: user),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: _gutter), // Gutter
                    Flexible(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(_columnPadding),
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            PostsPage(
                              container: ref.watch(accountProvider),
                              widget: widget,
                            ),
                            Container(),
                            Container(),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobile(
    AsyncSnapshot<User> snapshot,
    BoxConstraints constraints,
  ) {
    final Widget body;

    if (snapshot.hasError) {
      body = const IconLandingWidget(
        icon: Icon(Mdi.accountAlert),
        text: Text("Failed retrieving account"),
      );
    } else if (!snapshot.hasData) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      body = TabBarView(
        controller: _tabController,
        children: [
          PostsPage(
            container: ref.watch(accountProvider),
            widget: widget,
          ),
          Container(),
          Container(),
        ],
      );
    }

    final isLoading = !(snapshot.hasData || snapshot.hasError);
    final tooSmall = constraints.minWidth < 600;

    return Scaffold(
      body: body,
      appBar: snapshot.hasData //
          ? _buildAppBar(
              !(tooSmall || isLoading),
              snapshot,
            )
          : AppBar(),
    );
  }

  List<Tab> buildTabs(
    BuildContext context,
    User? user,
    bool showCountBadges,
    Axis direction,
  ) {
    final l10n = context.getL10n();
    return [
      buildTab(
        l10n.postsTab,
        user?.postCount ?? 0,
        showCountBadges,
        direction,
      ),
      buildTab(
        l10n.followersTab,
        user?.followerCount ?? 0,
        showCountBadges,
        direction,
      ),
      buildTab(
        l10n.followingTab,
        user?.followingCount ?? 0,
        showCountBadges,
        direction,
      ),
    ];
  }

  Tab buildTab(String text, int count, bool showCountBadges, Axis direction) {
    if (direction == Axis.horizontal) {
      return Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text),
            if (showCountBadges) buildBadge(context, count),
          ],
        ),
      );
    } else {
      final countLabel = shortenNumber(count);
      return Tab(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text),
            const SizedBox(height: 4.0),
            Text(countLabel),
            const SizedBox(height: 4.0),
          ],
        ),
      );
    }
  }

  AppBar _buildAppBar(
    bool showCountBadges,
    AsyncSnapshot<User<dynamic>> snapshot,
  ) {
    final bannerUrl = snapshot.data?.bannerUrl;

    return AppBar(
      actions: buildActions(context, user: snapshot.data),
      bottom: TabBar(
        tabs: buildTabs(
          context,
          snapshot.data,
          showCountBadges,
          Axis.horizontal,
        ),
        controller: _tabController,
      ),
      title: snapshot.data == null
          ? const SizedBox()
          : Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: AvatarWidget(
                    snapshot.data!,
                    size: 24,
                  ),
                ),
                Text(
                  snapshot.data?.displayName ?? "",
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
              ],
            ),
      flexibleSpace: FlexibleSpaceBar(
        background: bannerUrl == null
            ? null
            : Image.network(
                bannerUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox();
                },
              ),
      ),
    );
  }

  String shortenNumber(int count) {
    var text = count.toString();

    if (count / 1000 >= 1) {
      text = (count / 1000).toStringAsFixed(2) + 'k';
    }

    return text;
  }

  Widget buildBadge(BuildContext context, int count) {
    final text = shortenNumber(count);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.0),
        color: Colors.white,
      ),
      margin: const EdgeInsets.only(left: 6.0),
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
      child: Text(
        text,
        style: GoogleFonts.robotoMono(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        textScaleFactor: 0.9,
        overflow: TextOverflow.fade,
      ),
    );
  }

  List<Widget> buildActions(BuildContext context, {User? user}) {
    final l10n = context.getL10n();
    final url = user?.url;

    return [
      IconButton(
        tooltip: l10n.openInBrowserLabel,
        icon: const Icon(Mdi.openInNew),
        onPressed: url == null ? null : () => context.launchUrl(url),
      ),
    ];
  }
}

/// A vertical list describing the provided user.
class UserInfoWidget extends ConsumerWidget {
  const UserInfoWidget({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final joinDate = user.joinDate;
    final birthday = user.details.birthday;
    final location = user.details.location;
    final website = user.details.website;
    final fields = user.details.fields;
    final textRendererTheme = TextRendererTheme.fromContext(context, ref);

    final textStyle = TextStyle(color: Theme.of(context).disabledColor);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          user.renderDisplayName(context, ref),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          user.handle,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 12.0),
        Text.rich(user.renderDescription(context, ref)),
        const SizedBox(height: 12.0),
        if (fields != null)
          Table(
            columnWidths: const {
              0: IntrinsicColumnWidth(),
              1: FlexColumnWidth(),
            },
            children: [
              for (final field in fields.entries)
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                      child: Text.rich(
                        user.renderText(context, ref, field.key),
                        style: textStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text.rich(
                        user.renderText(context, ref, field.value),
                        style: textStyle,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        if (location != null)
          _UserInfoRow(
            leading: const Icon(Mdi.mapMarker),
            body: Text(location),
          ),
        if (website != null)
          _UserInfoRow(
            leading: const Icon(Mdi.linkVariant),
            body: Text.rich(
              TextSpan(
                text: website,
                style: textRendererTheme.linkTextStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => launch(website),
              ),
            ),
          ),
        if (joinDate != null)
          _UserInfoRow(
            leading: const Icon(Mdi.calendar),
            body: Text(
              "Joined ${DateFormat('MMMM yyyy').format(joinDate)}",
            ),
          ),
        if (birthday != null)
          _UserInfoRow(
            leading: const Icon(Mdi.cake),
            body: Text(
              "Born ${DateFormat('dd MMMM yyyy').format(birthday)}",
            ),
          ),
      ],
    );
  }
}

class _UserInfoRow extends StatelessWidget {
  final Icon leading;
  final Widget body;

  const _UserInfoRow({
    Key? key,
    required this.leading,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).disabledColor;
    const iconSize = 16.0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Baseline(
            baseline: iconSize,
            baselineType: TextBaseline.alphabetic,
            child: IconTheme(
              data: IconThemeData(color: color, size: iconSize),
              child: leading,
            ),
          ),
          const SizedBox(width: 6),
          DefaultTextStyle(
            style: TextStyle(color: color),
            child: Expanded(child: body),
          ),
        ],
      ),
    );
  }
}

class DesktopAccountHeader extends StatelessWidget {
  final TabController tabController;
  final List<Tab> tabs;
  final BoxConstraints constraints;
  final User? user;

  const DesktopAccountHeader({
    Key? key,
    required this.tabController,
    required this.tabs,
    required this.constraints,
    this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final avatarBorderRadius = BorderRadius.circular(8.0);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Stack(
      children: [
        Column(
          children: [
            Flexible(child: FlexibleSpaceBar(background: buildBackground())),
            ResponsiveLayoutBuilder(
              builder: (context, constraints, data) {
                return Row(
                  children: [
                    const Flexible(
                      fit: FlexFit.tight,
                      child: SizedBox(),
                    ),
                    const SizedBox(width: _gutter), // Gutter
                    Flexible(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: _columnPadding,
                        ),
                        child: TabBar(
                          controller: tabController,
                          tabs: tabs,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        Positioned.fill(
          child: SafeArea(
            child: ResponsiveLayoutBuilder(
              builder: (context, constraints, data) {
                // HACK(Craftplacer): Abusing Column to avoid vertical alignment from Center.
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            child: user == null
                                ? const SizedBox()
                                : DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: ElevationOverlay.applyOverlay(
                                        context,
                                        colorScheme.brightness ==
                                                Brightness.dark
                                            ? colorScheme.surface
                                            : colorScheme.primary,
                                        4.0,
                                      ),
                                      borderRadius: avatarBorderRadius * 4,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: AvatarWidget(
                                        user!,
                                        size: null,
                                        radius: avatarBorderRadius,
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(width: _gutter), // Gutter
                          const Flexible(flex: 3, child: SizedBox()),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        )
      ],
    );
  }

  Widget? buildBackground() {
    final url = user?.bannerUrl;
    if (url == null) {
      return null;
    } else {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const SizedBox(),
      );
    }
  }
}

class PostsPage extends StatelessWidget {
  const PostsPage({
    Key? key,
    required this.container,
    required this.widget,
  }) : super(key: key);

  final AccountManager container;
  final UserScreen widget;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Iterable<Post>>(
      future: container.adapter.getStatusesOfUserById(widget.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }

        return ListView.builder(
          itemBuilder: (_, i) => PostWidget(snapshot.data!.elementAt(i)),
          itemCount: snapshot.data?.length ?? 0,
        );
      },
    );
  }
}
