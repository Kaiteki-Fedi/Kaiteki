import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:intl/intl.dart";
import "package:kaiteki/text/rendering_extensions.dart";
import "package:kaiteki_core/model.dart";

class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementCard(this.announcement, {super.key});

  @override
  Widget build(BuildContext context) {
    final title = announcement.title;
    final createdAt = announcement.createdAt;
    final formattedCreatedAt = createdAt == null
        ? null
        : DateFormat.yMd(
            Localizations.localeOf(context).toString(),
          ).format(createdAt);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null) ...[
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
            ],
            Consumer(
              builder: (context, ref, _) {
                return Text.rich(
                  renderText(context, ref, announcement.content),
                );
              },
            ),
            if (createdAt != null) ...[
              const SizedBox(height: 8),
              Text(
                "Published at ${formattedCreatedAt}",
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
