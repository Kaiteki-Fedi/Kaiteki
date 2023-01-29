import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/model/emoji/emoji.dart";
import "package:kaiteki/fediverse/model/user/user.dart";
import "package:kaiteki/theming/kaiteki/text_theme.dart";
import "package:kaiteki/utils/extensions.dart";
import "package:kaiteki/utils/helpers.dart";
import "package:kaiteki/utils/text/text_renderer.dart";
import "package:url_launcher/url_launcher_string.dart";

/// A vertical list describing the provided user.
class UserInfoWidget extends ConsumerWidget {
  const UserInfoWidget({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final joinDate = user.joinDate;
    final birthday = user.details.birthday;
    final location = user.details.location;
    final website = user.details.website;
    final fields = user.details.fields;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          user.renderDisplayName(context, ref),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          user.handle.toString(),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        if (user.description != null) const SizedBox(height: 12.0),
        if (user.description != null)
          Text.rich(user.renderDescription(context, ref)),
        const SizedBox(height: 12.0),
        if (fields != null) _buildUserFieldsColumn(context, fields),
        if (location != null && location.isNotEmpty)
          _UserInfoRow(
            leading: const Icon(Icons.place_rounded),
            body: Text(location),
          ),
        if (website != null && website.isNotEmpty)
          _UserInfoRow(
            leading: const Icon(Icons.link_rounded),
            body: Text.rich(
              TextSpan(
                text: website,
                style: Theme.of(context).ktkTextTheme!.linkTextStyle,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => launchUrlString(website),
              ),
            ),
          ),
        if (joinDate != null)
          _UserInfoRow(
            leading: const Icon(Icons.event_rounded),
            body: Text(
              "Joined ${DateFormat('MMMM yyyy').format(joinDate)}",
            ),
          ),
        if (birthday != null)
          _UserInfoRow(
            leading: const Icon(Icons.cake_rounded),
            body: Text(
              "Born ${DateFormat('dd MMMM yyyy').format(birthday)}",
            ),
          ),
      ],
    );
  }

  // Table _buildUserFieldsTable(
  //   BuildContext context,
  //   Map<String, String> fields,
  // ) {
  //   final textStyle = TextStyle(color: Theme.of(context).disabledColor);
  //   return Table(
  //     columnWidths: const {
  //       0: IntrinsicColumnWidth(),
  //       1: FlexColumnWidth(),
  //     },
  //     children: [
  //       for (final field in fields.entries)
  //         TableRow(
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
  //               child: Text.rich(
  //                 user.renderText(context, field.key),
  //                 style: textStyle,
  //               ),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.only(bottom: 8.0),
  //               child: Text.rich(
  //                 user.renderText(context, field.value),
  //                 style: textStyle,
  //               ),
  //             ),
  //           ],
  //         ),
  //     ],
  //   );
  // }

  Widget _buildUserFieldsColumn(
    BuildContext context,
    Map<String, String> fields,
  ) {
    return Column(
      children: [
        for (final field in fields.entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _UserInfoFieldRow(
              field,
              emojis: user.emojis?.toList(growable: false) ?? [],
            ),
          ),
      ],
    );
  }
}

class _UserInfoFieldRow extends ConsumerWidget {
  final MapEntry<String, String> field;
  final List<Emoji> emojis;

  const _UserInfoFieldRow(this.field, {this.emojis = const []});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          field.key,
          style: TextStyle(color: Theme.of(context).disabledColor),
        ),
        const SizedBox(height: 4.0),
        Text.rich(
          render(
            context,
            field.value,
            textContext: TextContext(
              // FIXME(Craftplacer): Missing remoteHost
              emojiResolver: (e) => resolveEmoji(e, ref, null, emojis),
            ),
            onUserClick: (reference) => resolveAndOpenUser(
              reference,
              context,
              ref,
            ),
            textTheme: Theme.of(context).ktkTextTheme!,
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
    required this.leading,
    required this.body,
  });

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
