import "package:flutter/foundation.dart";
import "package:flutter/rendering.dart" show BoxConstraints;
import "package:kaiteki_core/social.dart" show ApplicationId;

const kAppName = "Kaiteki";
const kAppWebsite = "https://kaiteki.app/";
const kTelegramChannel = "https://t.me/kaiteki_fedi";
const kGithubRepository = "https://github.com/Kaiteki-Fedi/Kaiteki";
const kAppDescription = "The comfy SNS client for everything, everywhere";
const kUserAgent = "Kaiteki/1.0 (+$kAppWebsite)";
const kAppLegalese =
    "Licensed under the GNU Affero General Public License v3.0";

final kAppId = ApplicationId(
  name: kAppName,
  description: kAppDescription,
  icon: Uri.https("kaiteki.app", "/img/kaiteki.png"),
  website: Uri.https("kaiteki.app"),
);

const kFormWidth = 448.0;
const kFormHeight = 592.0;

/// https://m3.material.io/components/dialogs/specs#6771d107-624e-47cc-b6d8-2b7b620ba2f1
const kDialogConstraints = BoxConstraints(minWidth: 280, maxWidth: 560);

/// https://m3.material.io/components/bottom-sheets/specs#e69f3dfb-e443-46ba-b4a8-aabc718cf335
const kBottomSheetConstraints = BoxConstraints(maxWidth: 640);

/// Whether to use frontend login endpoints or oauth ones.
bool get useOAuth => !kIsWeb;

const kSplashRadius = 24.0;
