import 'package:breakpoint/breakpoint.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kaiteki/constants.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/adapter.dart';
import 'package:kaiteki/fediverse/instance_prober.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/logger.dart';
import 'package:kaiteki/preferences/app_experiment.dart';
import 'package:kaiteki/theming/kaiteki/text_theme.dart';
import 'package:kaiteki/ui/rounded_underline_tab_indicator.dart';
import 'package:kaiteki/ui/shared/async/async_button.dart';
import 'package:kaiteki/ui/shared/error_landing_widget.dart';
import 'package:kaiteki/ui/shared/layout/breakpoint_container.dart';
import 'package:kaiteki/ui/shared/posts/avatar_widget.dart';
import 'package:kaiteki/ui/shared/primary_tab_bar_theme.dart';
import 'package:kaiteki/ui/user/constants.dart';
import 'package:kaiteki/ui/user/desktop_user_header.dart';
import 'package:kaiteki/ui/user/user_info_widget.dart';
import 'package:kaiteki/ui/widgets/timeline.dart';
import 'package:kaiteki/utils/extensions.dart';

class UserScreen extends ConsumerStatefulWidget {
  final String id;
  final User? initialUser;

  const UserScreen.fromId(
    this.id, {
    super.key,
  }) : initialUser = null;

  UserScreen.fromUser(
    User this.initialUser, {
    super.key,
  }) : id = initialUser.id;

  @override
  ConsumerState<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends ConsumerState<UserScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  Future<User>? _future;
  ImageProvider? _bannerProvider;
  BackendAdapter? _adapterOverride;
  late bool remoteFetchPopupIgnored;
  late String id;

  static final _logger = getLogger('_UserScreenState');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);

    id = widget.id;
    remoteFetchPopupIgnored = !ref
        .read(preferencesProvider)
        .enabledExperiments
        .contains(AppExperiment.remoteUserFetching);

    final bannerUrl = widget.initialUser?.bannerUrl;
    if (bannerUrl != null) {
      _bannerProvider = NetworkImage(bannerUrl);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final adapter = ref.read(adapterProvider);
    try {
      _future ??= adapter.getUserById(id);
    } catch (e, s) {
      _logger.e("Failed to fetch user profile", e, s);
      _future = Future.error(e, s);
    }
  }

  @override
  Widget build(BuildContext context) {
    final body = FutureBuilder<User>(
      initialData: widget.initialUser,
      future: _future,
      builder: (_, snapshot) {
        return AppBarTabBarTheme(
          child: BreakpointBuilder(
            builder: (context, breakpoint) {
              return breakpoint.window < WindowSize.medium
                  ? _buildMobile(snapshot, breakpoint.window)
                  : _buildDesktop(context, snapshot, breakpoint);
            },
          ),
        );
      },
    );

    if (_adapterOverride != null) {
      return ProviderScope(
        overrides: [
          adapterProvider.overrideWith((ref) => _adapterOverride!),
        ],
        child: body,
      );
    }

    return body;
  }

  Widget? _buildBottomSheet(BuildContext context, User user) {
    final adapter = ref.read(adapterProvider);
    final isLocal =
        adapter is DecentralizedBackendAdapter && adapter.instance == user.host;
    if (_adapterOverride != null || remoteFetchPopupIgnored || isLocal) {
      return null;
    }

    return ConstrainedBox(
      constraints: bottomSheetConstraints,
      child: Material(
        elevation: 8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text("Would you like to fetch the remote profile?"),
              subtitle: Text(
                  "Kaiteki can display the user profile from its remote instance for more up-to-date details"),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      setState(() => remoteFetchPopupIgnored = true);
                    },
                    child: const Text("No thanks"),
                  ),
                  const SizedBox(width: 8),
                  AsyncButton(
                    onPressed: () async {
                      try {
                        // Fetch instance
                        final asyncValue = await ref.read(
                          probeInstanceProvider(user.host).future,
                        );

                        // initialize client
                        final adapter =
                            asyncValue.type!.createAdapter(user.host);

                        // override adapter being used with
                        // dependency injection
                        _adapterOverride = adapter;
                        final remoteUser = await _adapterOverride!.getUser(
                          user.username,
                        );

                        // refresh
                        setState(() {
                          id = remoteUser.id;
                          _future = Future.value(remoteUser);
                        });
                      } catch (e, s) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "We couldn't fetch the remote profile",
                            ),
                          ),
                        );
                        rethrow;
                      }
                    },
                    child: const Text("Fetch remote profile"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktop(
    BuildContext context,
    AsyncSnapshot<User> snapshot,
    Breakpoint breakpoint,
  ) {
    final user = snapshot.data;

    return Theme(
      data: Theme.of(context).copyWith(
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
              backgroundColor: Theme.of(context).useMaterial3
                  ? Theme.of(context).colorScheme.surfaceVariant
                  : null,
              scrolledUnderElevation: 0,
            ),
      ),
      child: Scaffold(
        bottomSheet: snapshot.data == null
            ? null
            : _buildBottomSheet(context, snapshot.data!),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                actions: buildActions(context, user: user),
                expandedHeight: user?.bannerUrl != null ? 450.0 : null,
                pinned: true,
                forceElevated: true,
                flexibleSpace: DesktopUserHeader(
                  tabController: _tabController,
                  tabs: buildTabs(context, user, true, Axis.horizontal),
                  user: user,
                ),
              ),
            ];
          },
          body: BreakpointContainer(
            breakpoint: breakpoint,
            child: Row(
              children: [
                Flexible(
                  child: Column(
                    children: [
                      if (user != null)
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(columnPadding),
                              child: UserInfoWidget(user: user),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(width: breakpoint.gutters),
                Flexible(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(columnPadding),
                    child: TabBarView(
                      controller: _tabController,
                      children: _buildPages(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPages() {
    return [
      Timeline.user(userId: id),
      Container(),
      Container(),
    ];
  }

  Widget _buildMobile(
    AsyncSnapshot<User> snapshot,
    WindowSize windowSize,
  ) {
    final Widget body;

    if (snapshot.hasError) {
      body = Center(child: ErrorLandingWidget.fromAsyncSnapshot(snapshot));
    } else if (!snapshot.hasData) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      body = TabBarView(
        controller: _tabController,
        children: _buildPages(),
      );
    }

    final isLoading = !(snapshot.hasData || snapshot.hasError);
    final tooSmall = windowSize < WindowSize.small;

    return Scaffold(
      appBar: snapshot.hasData //
          ? _buildAppBar(
              !(tooSmall || isLoading),
              tooSmall,
              snapshot,
            )
          : AppBar(),
      bottomSheet: snapshot.data == null
          ? null
          : _buildBottomSheet(context, snapshot.data!),
      body: body,
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

  Tab buildTab(String text, int? count, bool showCountBadges, Axis direction) {
    if (direction == Axis.horizontal) {
      return Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text),
            if (showCountBadges && count != null) ...[
              const SizedBox(width: 8),
              buildBadge(context, count),
            ],
          ],
        ),
      );
    } else {
      final countLabel = count == null ? null : _shortenNumber(context, count);
      return Tab(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text),
            const SizedBox(height: 4.0),
            if (countLabel != null) ...[
              Text(countLabel),
              const SizedBox(height: 4.0),
            ],
          ],
        ),
      );
    }
  }

  AppBar _buildAppBar(
    bool showCountBadges,
    bool isMobile,
    AsyncSnapshot<User<dynamic>> snapshot,
  ) {
    final displayName = snapshot.data?.renderDisplayName(context, ref);

    return AppBar(
      actions: [...buildActions(context, user: snapshot.data)],
      bottom: TabBar(
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.label,
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
                Flexible(
                  child: displayName == null
                      ? const Text("...")
                      : Text.rich(
                          displayName,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                ),
              ],
            ),
      flexibleSpace: FlexibleSpaceBar(
        background: _bannerProvider == null
            ? null
            : Opacity(
                opacity: 0.25,
                child: Image(
                  image: _bannerProvider!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox();
                  },
                ),
              ),
      ),
    );
  }

  Widget buildBadge(BuildContext context, int count) {
    final textStyle = Theme.of(context).ktkTextTheme?.countTextStyle;
    final fontSize = Theme.of(context).textTheme.labelSmall?.fontSize;
    return DecoratedBox(
      decoration: ShapeDecoration(
        shape: const StadiumBorder(),
        color: Theme.of(context).colorScheme.inverseSurface,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 16,
          minHeight: 16,
          maxHeight: 16,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 4.0,
          ),
          child: Center(
            child: Text(
              _shortenNumber(context, count),
              style: textStyle?.copyWith(
                color: Theme.of(context).colorScheme.onInverseSurface,
                fontSize: fontSize,
                height: (fontSize ?? 0) / 16,
              ),
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }

  String _shortenNumber(BuildContext context, num value) {
    final locale = Localizations.localeOf(context);
    final numberFormat = NumberFormat.compact(locale: locale.languageCode);
    return numberFormat.format(value);
  }

  List<Widget> buildActions(BuildContext context, {User? user}) {
    final l10n = context.getL10n();
    final url = user?.url;

    return [
      IconButton(
        tooltip: l10n.openInBrowserLabel,
        icon: const Icon(Icons.open_in_new_rounded),
        onPressed: url == null ? null : () => context.launchUrl(url),
      ),
    ];
  }
}
