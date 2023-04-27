import "dart:io";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:kaiteki/fediverse/model/model.dart";
import "package:kaiteki/ui/share_sheet/sheet.dart";
import "package:share_plus/share_plus.dart";

Future<void> share(BuildContext context, Object content) async {
  if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
    final text = getShareText(content);
    await Share.share(text);
    return;
  }

  await showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    builder: (context) => ShareSheet(content),
  );
}

Uri? getShareUrl(Object content) {
  if (content is Uri) return content;
  if (content is User) return content.url;
  if (content is Post) return content.externalUrl;
  return null;
}

String getShareText(Object content) {
  if (content is String) return content;

  final url = getShareUrl(content);
  if (url != null) return url.toString();

  throw UnimplementedError();
}
