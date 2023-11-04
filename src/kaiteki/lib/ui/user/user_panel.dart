import "package:flutter/material.dart";
import "package:fpdart/fpdart.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/people/dialog.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/user/text_with_icon.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/social.dart";

class UserPanel extends ConsumerWidget {
  final User user;

  const UserPanel(this.user, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayName = user.displayName;
    final description = user.description;

    final displayNameTextStyle = Theme.of(context).textTheme.titleLarge;
    final followerCount = user.metrics.followerCount;
    final followingCount = user.metrics.followingCount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (displayName != null)
          Text.rich(
            user.renderDisplayName(context, ref),
            style: displayNameTextStyle,
          )
        else
          Text(user.username, style: displayNameTextStyle),
        const SizedBox(height: 8.0),
        Text(
          user.handle.toString(),
          style: Theme.of(context).colorScheme.onSurfaceVariant.textStyle,
        ),
        // const SizedBox(height: 8.0),
        // const FederationDisclaimer(),
        if (description != null && description.isNotEmpty) ...[
          const SizedBox(height: 8.0),
          SelectableText.rich(
            TextSpan(children: [user.renderDescription(context, ref)]),
          ),
        ],
        const SizedBox(height: 16.0),
        if (user.details.fields != null)
          Table(
            columnWidths: const {
              0: FlexColumnWidth(),
              1: FlexColumnWidth(2),
            },
            children: [
              for (final field in user.details.fields!.entries)
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 8.0,
                        right: 8.0,
                      ),
                      child: Text(
                        field.key,
                        style: Theme.of(context).colorScheme.outline.textStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 8.0,
                      ),
                      child: Text.rich(
                        user.renderText(
                          context,
                          ref,
                          field.value,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
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
              spacing: 16.0,
              children: [
                if (user.joinDate != null)
                  TextWithIcon(
                    icon: const Icon(Icons.today_rounded),
                    text: Text(context.l10n.userJoinDate(user.joinDate!)),
                  ),
                if (user.details.birthday != null)
                  TextWithIcon(
                    icon: const Icon(Icons.cake_rounded),
                    text: Text(
                      context.l10n.userBirthDate(user.details.birthday!),
                    ),
                  ),
                if (user.details.location != null)
                  TextWithIcon(
                    icon: const Icon(Icons.location_on_rounded),
                    text: Text(user.details.location!),
                  ),
                if (user.details.website != null)
                  TextWithIcon(
                    icon: const Icon(Icons.link_rounded),
                    text: Text(user.details.website!),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        _FollowerBar.fromUser(user: user),
      ],
    );
  }
}

class _FollowerBar extends StatelessWidget {
  const _FollowerBar({
    super.key,
    required this.followingCount,
    required this.followerCount,
    required this.userId,
  });

  factory _FollowerBar.fromUser({
    Key? key,
    required User user,
  }) {
    return _FollowerBar(
      key: key,
      followingCount: user.metrics.followingCount,
      followerCount: user.metrics.followerCount,
      userId: user.id,
    );
  }

  final int? followingCount;
  final int? followerCount;
  final String userId;

  @override
  Widget build(BuildContext context) {
    final followingCount = this.followingCount;
    final followerCount = this.followerCount;

    return InkWell(
      child: Text.rich(
        TextSpan(
          children: [
            if (followingCount != null && followingCount > 0)
              "$followingCount following",
            if (followerCount != null && followerCount > 0)
              "$followerCount followers",
          ]
              .map((e) => TextSpan(text: e))
              .intersperse(const TextSpan(text: " • "))
              .toList(),
          style: Theme.of(context).colorScheme.outline.textStyle,
        ),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => PeopleDialog(userId: userId),
          useRootNavigator: false,
        );
      },
    );
  }
}
