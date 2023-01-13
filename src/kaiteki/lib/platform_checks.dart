import "dart:io";

import "package:flutter/foundation.dart";

bool get supportsVideoPlayer => kIsWeb || _isMobileOS;

const kBuildFlavor = bool.hasEnvironment("BUILD_FLAVOR")
    ? String.fromEnvironment("BUILD_FLAVOR")
    : null;

// share_plus
bool get supportsDedicatedSharing =>
    kIsWeb || !(Platform.isWindows || Platform.isLinux);

// HACK(Craftplacer): I'd prefer an actual system call to check whether a hard keyboard is attached
bool get hasPhysicalKeyboard => kIsWeb || !_isMobileOS;

bool get _isMobileOS => Platform.isAndroid || Platform.isIOS;
