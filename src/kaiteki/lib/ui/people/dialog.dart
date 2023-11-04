import "package:flutter/material.dart";
import "package:kaiteki/constants.dart";
import "package:kaiteki/ui/shared/icon_landing_widget.dart";
import "package:kaiteki/ui/user/user_sliver.dart";

class PeopleDialog extends StatelessWidget {
  final String userId;

  const PeopleDialog({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Dialog(
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: kDialogConstraints.copyWith(maxHeight: 560),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                title: const Text("People"),
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                forceMaterialTransparency: true,
              ),
              const TabBar(
                tabs: [
                  Tab(text: "Featured"),
                  Tab(text: "Following"),
                  Tab(text: "Followers"),
                ],
              ),
              Flexible(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
