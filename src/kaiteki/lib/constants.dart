import "package:flutter/foundation.dart";
import "package:flutter/rendering.dart" show BoxConstraints;
import "package:kaiteki_core/social.dart" show ApplicationId;

const String appName = "Kaiteki";
const String appWebsite = "https://kaiteki.app/";
const String telegramChannel = "https://t.me/kaiteki_fedi";
const String githubRepository = "https://github.com/Kaiteki-Fedi/Kaiteki";
const String appDescription = "The comfy Fediverse client";
const String userAgent = "Kaiteki/1.0 (+$appWebsite)";
const String appLegalese =
    "Licensed under the GNU Affero General Public License v3.0";

final appId = ApplicationId(
  name: appName,
  description: appDescription,
  icon: Uri.https("kaiteki.app", "/img/kaiteki.png"),
  website: Uri.https("kaiteki.app"),
);

const double defaultFormWidth = 448;
const double defaultFormHeight = 592;
const dialogConstraints = BoxConstraints(minWidth: 280, maxWidth: 560);
// https://m3.material.io/components/bottom-sheets/specs#e69f3dfb-e443-46ba-b4a8-aabc718cf335
const bottomSheetConstraints = BoxConstraints(maxWidth: 640);

/// Whether to use frontend login endpoints or oauth ones.
bool get useOAuth => !kIsWeb;

const double defaultSplashRadius = 24.0;
