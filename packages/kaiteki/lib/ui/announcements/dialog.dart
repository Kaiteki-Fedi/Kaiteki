import "package:flutter/material.dart";
import "package:kaiteki/constants.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/fediverse/services/announcements.dart";
import "package:kaiteki/ui/announcements/card.dart";
import "package:kaiteki/ui/shared/common.dart";
import "package:kaiteki/ui/shared/error_landing_widget.dart";
import "package:kaiteki/ui/shared/icon_landing_widget.dart";

class AnnouncementsDialog extends ConsumerStatefulWidget {
  const AnnouncementsDialog({super.key});

  @override
  ConsumerState<AnnouncementsDialog> createState() =>
      _AnnouncementsDialogState();
}

class _AnnouncementsDialogState extends ConsumerState<AnnouncementsDialog> {
  @override
  Widget build(BuildContext context) {
    final key = ref.read(currentAccountProvider)!.key;
    final provider = announcementsServiceProvider(key);

    final body = ref.watch(provider).map(
          data: (e) {
            final announcements = e.value;

            if (announcements.isEmpty) {
              return const IconLandingWidget(
                icon: Icon(Icons.campaign_rounded),
                text: Text("New announcements will appear here."),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              itemCount: announcements.length,
              itemBuilder: (_, i) => AnnouncementCard(announcements[i]),
              separatorBuilder: (_, __) => const SizedBox(height: 8.0),
            );
          },
          loading: (_) => centeredCircularProgressIndicator,
          error: (e) => ErrorLandingWidget((e.error, e.stackTrace)),
        );

    final closeButton = IconButton(
      icon: const Icon(Icons.close),
      onPressed: () => Navigator.of(context).pop(),
    );

    final refreshButton = IconButton(
      icon: const Icon(Icons.refresh),
      onPressed: () => ref.refresh(provider),
    );

    if (WindowWidthSizeClass.fromContext(context) <=
        WindowWidthSizeClass.compact) {
      return Dialog.fullscreen(
        child: Column(
          children: [
            AppBar(
              leading: closeButton,
              title: const Text("Announcements"),
              forceMaterialTransparency: true,
              actions: [refreshButton, kAppBarActionsSpacer],
            ),
            Expanded(child: body),
          ],
        ),
      );
    }

    return Dialog(
      child: ConstrainedBox(
        constraints: kDialogConstraints.copyWith(
          maxHeight: kDialogConstraints.maxWidth,
        ),
        child: Column(
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              title: const Text("Announcements"),
              forceMaterialTransparency: true,
              actions: [refreshButton, closeButton, kAppBarActionsSpacer],
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
