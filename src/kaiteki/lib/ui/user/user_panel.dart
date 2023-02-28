import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/model/user/user.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/user/federation_disclaimer.dart";
import "package:kaiteki/ui/user/text_with_icon.dart";
import "package:kaiteki/utils/extensions.dart";

class UserPanel extends ConsumerWidget {
  final User user;

  const UserPanel(this.user, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayName = user.displayName;
    final description = user.description;

    final displayNameTextStyle = Theme.of(context).textTheme.titleLarge;
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
        const SizedBox(height: 8.0),
        const FederationDisclaimer(),
        if (description != null && description.isNotEmpty) ...[
          const SizedBox(height: 8.0),
          Text.rich(user.renderDescription(context, ref)),
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
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                        ),
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
                    text: Text(
                      "Joined ${DateFormat('MMMM yyyy').format(user.joinDate!)}",
                    ),
                  ),
                if (user.details.birthday != null)
                  TextWithIcon(
                    icon: const Icon(Icons.cake_rounded),
                    text: Text(
                      "Born ${DateFormat('dd MMMM yyyy').format(user.details.birthday!)}",
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
        )
      ],
    );
  }
}
