bool get supportsVideoPlayer => kIsWeb || _isMobileOS;

const kBuildFlavor = bool.hasEnvironment("BUILD_FLAVOR")
    ? String.fromEnvironment("BUILD_FLAVOR")
    : null;
