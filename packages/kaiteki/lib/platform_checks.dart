import "dart:io";

import "package:flutter/foundation.dart";

bool get supportsVideoPlayer => kIsWeb || Platform.isAndroid || Platform.isIOS;

const kBuildFlavor = bool.hasEnvironment("BUILD_FLAVOR")
    ? String.fromEnvironment("BUILD_FLAVOR")
    : null;

bool get hasDedicatedMediaPicker =>
    kIsWeb || Platform.isAndroid || Platform.isIOS;
