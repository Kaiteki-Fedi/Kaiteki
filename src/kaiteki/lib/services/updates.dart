import 'package:kaiteki/di.dart';
import 'package:meta/meta.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'updates.g.dart';

@Riverpod(keepAlive: true)
class UpdateService extends _$UpdateService {
  @override
  FutureOr<KaitekiRelease?> build() async {
    ref.read(preferencesProvider).checkedForUpdatesAt = DateTime.now();
    return Future.delayed(
      const Duration(seconds: 1),
      () => KaitekiRelease(
        versionName: "Weekly 2023-69",
        versionTag: "69696",
        versionCode: "123123",
        urls: {
          KaitekiReleaseUrlType.androidApkArm64: Uri.parse(
            "https://github.com/Kaiteki-Fedi/Kaiteki/releases/download/weekly-2023-02/app-arm64-v8a-release.apk",
          ),
        },
      ),
    );
  }
}

@immutable
class KaitekiRelease {
  final String versionName;
  final String versionTag;
  final String versionCode;
  final Map<KaitekiReleaseUrlType, Uri> urls;

  const KaitekiRelease({
    required this.versionName,
    required this.versionTag,
    required this.versionCode,
    this.urls = const {},
  });
}

enum KaitekiReleaseUrlType {
  /// app-armeabi-v7a-release.apk
  androidApkArm32,

  /// app-arm64-v8a-release.apk
  androidApkArm64,

  /// app-x86_64-release.apk
  androidApkX86_64,

  githubRelease,

  linuxBinary,

  windowsBinary,

  /// Kaiteki-x86_64.AppImage
  linuxAppImage,
}
