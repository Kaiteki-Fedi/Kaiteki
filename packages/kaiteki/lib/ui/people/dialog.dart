import "package:flutter/material.dart";
import "package:kaiteki/constants.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/icon_landing_widget.dart";
import "package:kaiteki/ui/user/user_sliver.dart";

class PeopleDialog extends StatelessWidget {
  final String userId;

  const PeopleDialog({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final windowClass = WindowWidthSizeClass.fromContext(context);

    final Widget dialog;

    final closeButton = IconButton(
      icon: const Icon(Icons.close),
      onPressed: () => Navigator.of(context).pop(),
      tooltip: context.materialL10n.closeButtonTooltip,
    );

    final tabBar = TabBar(
      tabs: [
        Tab(text: context.l10n.featuredTab),
        Tab(text: context.l10n.followingTab),
        Tab(text: context.l10n.followersTab),
      ],
    );

    final body = Flexible(
      child: TabBarView(
        children: [
          const Center(
            child: IconLandingWidget(
              icon: Icon(Icons.push_pin_rounded),
              text: Text("Featured people are not implemented yet."),
            ),
          ),
          CustomScrollView(
            slivers: [UserSliver.following(userId: userId)],
          ),
          CustomScrollView(
            slivers: [UserSliver.followers(userId: userId)],
          ),
        ],
      ),
    );

    if (windowClass <= WindowWidthSizeClass.compact) {
      dialog = Dialog.fullscreen(
        child: Column(
          children: [
            AppBar(
              title: Text(context.l10n.peopleDialogTitle),
              leading: closeButton,
              forceMaterialTransparency: true,
            ),
            tabBar,
            body,
          ],
        ),
      );
    } else {
      dialog = Dialog(
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: kDialogConstraints.copyWith(maxHeight: 560),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                automaticallyImplyLeading: false,
                title: Text(context.l10n.peopleDialogTitle),
                forceMaterialTransparency: true,
                actions: [closeButton, kAppBarActionsSpacer],
              ),
              tabBar,
              body,
            ],
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 3,
      child: dialog,
    );
  }
}
