import "package:flutter/material.dart";
import "package:kaiteki/ui/share_sheet/sheet.dart";
import "package:kaiteki_core/model.dart";

Future<void> share(BuildContext context, Object content) async {
  await showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    builder: (context) => ShareSheet(content),
  );
}

Uri? getShareUrl(Object content, {bool preferRemote = true}) {
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
