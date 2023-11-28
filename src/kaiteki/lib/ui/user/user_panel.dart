import "package:flutter/material.dart";
import "package:flutter/semantics.dart";
import "package:fpdart/fpdart.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/ui/people/dialog.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/user/profile_link.dart";
import "package:kaiteki/ui/user/text_with_icon.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/social.dart";
import "package:url_launcher/url_launcher.dart";

class UserPanel extends ConsumerStatefulWidget {
  final User user;

  const UserPanel(this.user, {super.key});

  @override
  ConsumerState<UserPanel> createState() => _UserPanelState();
}

class _FollowerBar extends StatelessWidget {
  final int? followingCount;

  final int? followerCount;

  final String userId;

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

class _ProfileAttributes extends StatelessWidget {
  final DateTime? joinDate;
  final DateTime? birthday;
  final String? location;
  final String? website;

  const _ProfileAttributes({
    super.key,
    this.joinDate,
    this.birthday,
    this.location,
    this.website,
  });

  factory _ProfileAttributes.fromUser({
    Key? key,
    required User user,
  }) {
    return _ProfileAttributes(
      key: key,
      joinDate: user.joinDate,
      birthday: user.details.birthday,
      location: user.details.location,
      website: user.details.website,
    );
  }

  @override
  Widget build(BuildContext context) {
    final joinDate = this.joinDate;
    final birthday = this.birthday;
    final location = this.location;
    final website = this.website;

    final outline = Theme.of(context).colorScheme.outline;
    return IconTheme(
      data: IconThemeData(color: outline, size: 16.0),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: outline),
        child: Wrap(
          spacing: 16.0,
          children: [
            if (joinDate != null)
              TextWithIcon(
                icon: const Icon(Icons.today_rounded),
                text: Text(context.l10n.userJoinDate(joinDate)),
              ),
            if (birthday != null)
              TextWithIcon(
                icon: const Icon(Icons.cake_rounded),
                text: Text(
                  context.l10n.userBirthDate(birthday),
                ),
              ),
            if (location != null)
              TextWithIcon(
                icon: const Icon(Icons.location_on_rounded),
                text: Text(location),
              ),
            if (website != null)
              TextWithIcon(
                icon: const Icon(Icons.link_rounded),
                text: Text(website),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProfileFields extends StatelessWidget {
  final User user;

  final List<MapEntry<String, String>> fields;

  const _ProfileFields({required this.user, required this.fields});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).colorScheme.outline.textStyle;
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(),
        1: FlexColumnWidth(2),
      },
      children: [
        for (final field in fields)
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                child: Text(field.key, style: textStyle),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Consumer(
                  builder: (context, ref, _) {
                    final textSpan = user.renderText(context, ref, field.value);
                    return Text.rich(textSpan);
                  },
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _UserPanelState extends ConsumerState<UserPanel> {
  List<MapEntry<String, String>>? _fields;
  List<ProfileLink>? _links;

  @override
  Widget build(BuildContext context) {
    final displayNameTextStyle = Theme.of(context).textTheme.titleLarge;

    final displayName = widget.user.displayName;
    final description = widget.user.description;
    final fields = _fields;
    final links = _links;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          sortKey: const OrdinalSortKey(0),
          header: true,
          child: Text.rich(
            displayName == null
                ? TextSpan(text: widget.user.username)
                : widget.user.renderDisplayName(context, ref),
            style: displayNameTextStyle,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          widget.user.handle.toString(),
          style: Theme.of(context).colorScheme.onSurfaceVariant.textStyle,
        ),
        if (description != null && description.isNotEmpty) ...[
          const SizedBox(height: 8.0),
          SelectableText.rich(
            TextSpan(children: [widget.user.renderDescription(context, ref)]),
          ),
        ],
        const SizedBox(height: 16.0),
        if (fields != null && fields.isNotEmpty)
          _ProfileFields(fields: fields, user: widget.user),
        if (links != null && links.isNotEmpty) ...[
          Wrap(
            children: [
              for (final link in links)
                IconButton(
                  icon: Icon(link.$1),
                  tooltip: link.$2,
                  onPressed: () => launchUrl(link.$3),
                ),
            ],
          ),
        ],
        const SizedBox(height: 8.0),
        _ProfileAttributes.fromUser(user: widget.user),
        const SizedBox(height: 8.0),
        _FollowerBar.fromUser(user: widget.user),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    final fields = widget.user.details.fields;
    if (fields != null) {
      final result = extractLinksFromFields(fields);
      _fields = result.$1;
      _links = result.$2;
    }
  }
}
