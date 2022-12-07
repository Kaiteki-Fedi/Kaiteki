import 'package:breakpoint/breakpoint.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/ui/rounded_underline_tab_indicator.dart';
import 'package:kaiteki/ui/shared/layout/breakpoint_container.dart';
import 'package:kaiteki/ui/shared/posts/avatar_widget.dart';
import 'package:kaiteki/ui/shared/primary_tab_bar_theme.dart';
import 'package:kaiteki/ui/user/constants.dart';

class DesktopUserHeader extends StatelessWidget {
  final TabController tabController;
  final List<Tab> tabs;
  final User? user;

  const DesktopUserHeader({
    super.key,
    required this.tabController,
    required this.tabs,
    this.user,
  });

  Color getAppBarBackgroundColor(BuildContext context) {
    final inheritedColor = AppBarTheme.of(context).backgroundColor;

    if (inheritedColor != null) return inheritedColor;

    return Theme.of(context).colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    final avatarBorderRadius = BorderRadius.circular(8.0);
    // final foregroundColor = Theme.of(context).useMaterial3
    //     ? Theme.of(context).colorScheme.onSurface
    //     : Theme.of(context).colorScheme.onPrimary;

    return BreakpointBuilder(
      builder: (context, breakpoint) {
        return Stack(
          children: [
            Column(
              children: [
                Flexible(
                  child: FlexibleSpaceBar(background: buildBackground()),
                ),
                BreakpointContainer(
                  breakpoint: breakpoint,
                  child: Row(
                    children: [
                      const Flexible(
                        fit: FlexFit.tight,
                        child: SizedBox(),
                      ),
                      SizedBox(width: breakpoint.gutters),
                      Flexible(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: columnPadding,
                          ),
                          child: AppBarTabBarTheme(
                            child: TabBar(
                              indicatorSize: TabBarIndicatorSize.label,
                              controller: tabController,
                              tabs: tabs,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned.fill(
              child: SafeArea(
                child: BreakpointContainer(
                  breakpoint: breakpoint,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: user == null
                                ? const SizedBox()
                                : _buildAvatar(context, avatarBorderRadius),
                          ),
                        ),
                        const SizedBox(width: gutter), // Gutter
                        const Flexible(flex: 3, child: SizedBox()),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  DecoratedBox _buildAvatar(
    BuildContext context,
    BorderRadius borderRadius,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: ElevationOverlay.applyOverlay(
          context,
          getAppBarBackgroundColor(context),
          4.0,
        ),
        borderRadius: borderRadius * 2,
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: AvatarWidget(
          user!,
          size: null,
          radius: borderRadius,
        ),
      ),
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
