import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:flutter/semantics.dart";
import "package:fpdart/fpdart.dart";
import "package:kaiteki/api/listenbrainz.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/ui/people/dialog.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/user/text_with_icon.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki_core/kaiteki_core.dart";
import "package:kaiteki_core/social.dart";
import "package:logging/logging.dart";
import "package:url_launcher/url_launcher.dart";

import "now_playing.dart";

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

    final hasFollowing = followingCount != null && followingCount > 0;
    final hasFollowers = followerCount != null && followerCount > 0;

    void onTap() {
      showDialog(
        context: context,
        builder: (_) => PeopleDialog(userId: userId),
        useRootNavigator: false,
      );
    }

    final l10n = context.l10n;
    if (!(hasFollowers && hasFollowing)) {
      return InkWell(
        onTap: onTap,
        child: Text.rich(
          TextSpan(
            text: l10n.peopleDialogButtonLabel,
            style: Theme.of(context).colorScheme.outline.textStyle,
          ),
        ),
      );
    }

    final text = [
      if (hasFollowing) l10n.followingCount(followingCount),
      if (hasFollowers) l10n.followerCount(followerCount),
    ];

    assert(text.isNotEmpty);

    return InkWell(
      onTap: onTap,
      child: Text.rich(
        TextSpan(
          children: text
              .map((e) => TextSpan(text: e))
              .intersperse(const TextSpan(text: " • "))
              .toList(),
          style: Theme.of(context).colorScheme.outline.textStyle,
        ),
      ),
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
  Future<(TrackMetadata, Uri?)?>? _trackFuture;

  @override
  void initState() {
    super.initState();

    Future<(TrackMetadata, Uri?)?> fetchNowPlaying(String username) async {
      final payload = await getNowPlaying(username);
      if (payload.playingNow != true) return null;

      final listen =
          payload.listens.firstWhereOrNull((e) => e.playingNow == true);
      final trackMetadata = listen?.trackMetadata;

      if (trackMetadata == null) return null;

      final lookup = await lookupMetadata(
        artistName: trackMetadata.artistName,
        recordingName: trackMetadata.trackName,
        include: const ["release"],
      );
      final release = lookup.metadata?.release;
      final caaReleaseMbid = release?.caaReleaseMbid;
      final caaId = release?.caaId;
      final coverArtUrl = caaReleaseMbid != null && caaId != null
          ? Uri.parse(
              "https://archive.org/download/mbid-$caaReleaseMbid/mbid-$caaReleaseMbid-${caaId}_thumb250.jpg",
            )
          : null;

      return (trackMetadata, coverArtUrl);
    }

    _trackFuture = widget.user.details.listenbrainz.andThen(fetchNowPlaying);

    final fields = widget.user.details.fields;
    _fields = fields;
  }

  @override
  Widget build(BuildContext context) {
    final displayNameTextStyle = Theme.of(context).textTheme.titleLarge;

    final displayName = widget.user.displayName;
    final description = widget.user.description;
    final fields = _fields;
    // final links = _links;

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
        if (_trackFuture != null)
          FutureBuilder(
            future: _trackFuture,
            builder: (context, snapshot) {
              final data = snapshot.data;
              if (data != null) {
                return Column(
                  children: [
                    NowPlayingCard(
                      title: data.$1.trackName,
                      artist: data.$1.artistName,
                      album: data.$1.releaseName,
                      coverArtUrl: data.$2,
                      trackUrl: data.$1.additionalInfo?.originUrl,
                    ),

                    const SizedBox(height: 8.0),
                  ],
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        if (fields != null && fields.isNotEmpty)
          _ProfileFields(fields: fields, user: widget.user),
        const SizedBox(height: 8.0),
        _ProfileAttributes.fromUser(user: widget.user),
        const SizedBox(height: 8.0),
        _FollowerBar.fromUser(user: widget.user),
      ],
    );
  }
}
