import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/model/user.dart';
import 'package:kaiteki/utils/extensions.dart';
import 'package:kaiteki/utils/text/text_renderer.dart';
import 'package:url_launcher/url_launcher_string.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          user.renderDisplayName(context),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          user.handle,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        if (user.description != null) const SizedBox(height: 12.0),
        if (user.description != null)
          Text.rich(user.renderDescription(context)),
        const SizedBox(height: 12.0),
        if (fields != null)
          false
              ? _buildUserFieldsTable(context, fields)
              : _buildUserFieldsColumn(context, fields),
        if (location != null)
          _UserInfoRow(
            leading: const Icon(Icons.place_rounded),
            body: Text(location),
          ),
        if (website != null)
          _UserInfoRow(
            leading: const Icon(Icons.link_rounded),
            body: Text.rich(
              TextSpan(
                text: website,
                style: context.getKaitekiTheme()!.linkTextStyle,
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

  Table _buildUserFieldsTable(
    BuildContext context,
    Map<String, String> fields,
  ) {
    final textStyle = TextStyle(color: Theme.of(context).disabledColor);
    return Table(
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
                  user.renderText(context, field.key),
                  style: textStyle,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text.rich(
                  user.renderText(context, field.value),
                  style: textStyle,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildUserFieldsColumn(
    BuildContext context,
    Map<String, String> fields,
  ) {
    return Column(
      children: [
        for (final field in fields.entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _UserInfoFieldRow(field),
          ),
      ],
    );
  }
}

class _UserInfoFieldRow extends StatelessWidget {
  final MapEntry<String, String> field;

  const _UserInfoFieldRow(this.field);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          field.key,
          style: TextStyle(color: Theme.of(context).disabledColor),
        ),
        const SizedBox(height: 4.0),
        Text.rich(
          const TextRenderer().render(
            context,
            field.value,
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
