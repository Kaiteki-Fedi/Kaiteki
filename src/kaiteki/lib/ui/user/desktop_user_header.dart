import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/ui/shared/posts/avatar_widget.dart';
import 'package:kaiteki/ui/user/constants.dart';
import 'package:kaiteki/utils/layout_helper.dart';

class DesktopUserHeader extends StatelessWidget {
  final TabController tabController;
  final List<Tab> tabs;
  final BoxConstraints constraints;
  final User? user;

  const DesktopUserHeader({
    Key? key,
    required this.tabController,
    required this.tabs,
    required this.constraints,
    this.user,
  }) : super(key: key);

  Color getAppBarBackgroundColor(ThemeData theme) {
    if (theme.appBarTheme.backgroundColor != null) {
      return theme.appBarTheme.backgroundColor!;
    }
    return theme.primaryColor;
    //return theme.colorScheme.brightness == Brightness.dark
    //    ? theme.colorScheme.surface
    //    : theme.colorScheme.primary;
  }

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
                    const SizedBox(width: gutter), // Gutter
                    Flexible(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: columnPadding,
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
                                        getAppBarBackgroundColor(theme),
                                        4.0,
                                      ),
                                      borderRadius: avatarBorderRadius * 2,
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
                          const SizedBox(width: gutter), // Gutter
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
