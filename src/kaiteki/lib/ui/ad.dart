import "dart:math";

import "package:flutter/material.dart";
import "package:kaiteki/di.dart";
import "package:kaiteki/preferences/app_preferences.dart";
import "package:kaiteki/preferences/theme_preferences.dart";
import "package:kaiteki/ui/shared/dialogs/link_warning_dialog.dart";
import "package:kaiteki_core/model.dart";
import "package:kaiteki_core/utils.dart";
import "package:url_launcher/url_launcher.dart";

final adsProvider = Provider(
  (ref) {
    return ref.watch(
      currentAccountProvider.select((account) => account?.instance?.ads),
    );
  },
  dependencies: [currentAccountProvider],
);

class AdWidget extends ConsumerStatefulWidget {
  const AdWidget({super.key});

  @override
  ConsumerState<AdWidget> createState() => _AdWidgetState();
}

class _AdWidgetState extends ConsumerState<AdWidget> {
  late final Ad _ad;

  static final _random = Random();

  @override
  void initState() {
    super.initState();

    final ads = ref.read(adsProvider)!;
    _ad = ads[_random.nextInt(ads.length)];
  }

  @override
  Widget build(BuildContext context) {
    final displayAsCard = ref.watch(usePostCards).value;

    return ClipRRect(
      clipBehavior: displayAsCard ? Clip.antiAlias : Clip.none,
      borderRadius:
          displayAsCard ? BorderRadius.circular(8) : BorderRadius.zero,
      child: Stack(
        children: [
          InkWell(
            onTap: _ad.linkUrl == null ? null : open,
            child: Image(
              image: NetworkImage(_ad.imageUrl.toString()),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IconButton.filledTonal(
              onPressed: () {
                ref.read(showAds).value = false;
              },
              tooltip: "Disable ads",
              icon: Icon(Icons.close_rounded),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> open() async {
    final url = _ad.linkUrl;

    assert(url != null);
    if (url == null) return;

    final showWarning = switch (ref.read(linkWarningPolicy).value) {
      LinkWarningPolicy.never => false,
      LinkWarningPolicy.onAds => true,
      LinkWarningPolicy.always => true,
    };

    if (showWarning) {
      final result = await showDialog<bool>(
        context: context,
        builder: (_) => LinkWarningDialog(url),
      );

      if (result != true) return;
    }

    await launchUrl(url);
  }
}
