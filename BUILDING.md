# Building Kaiteki

## Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install)
  - Kaiteki is running on the Flutter **master** branch. Prefer checking the [SDK releases page](https://docs.flutter.dev/development/tools/sdk/releases).
  - Change the branch of your Flutter SDK installation with `flutter channel master` and then `flutter upgrade`.
- [Melos](https://pub.dev/packages/melos)
  - Kaiteki uses melos for managing dart projects as a monorepo
- A supported IDE like [Visual Studio Code](https://code.visualstudio.com/), [IntelliJ](https://www.jetbrains.com/idea/), or [Android Studio](https://developer.android.com/studio/) *(optional)*
- Build tools for the platform you want to compile for
  - **Android:** See Flutter "Getting Started" guide for setting up the Android SDK, otherwise download <https://developer.android.com/studio#command-line-tools-only> and set SDK path with `flutter config --android-studio-dir`
  - **Windows:** [Visual Studio](https://visualstudio.microsoft.com/downloads/) or [Build Tools for Visual Studio 2022](https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022) with "Desktop development with C++" workload
  - **Linux:**
    - **Debian-based:** `clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev libhandy-1-dev`
    - **Void Linux:** `clang cmake ninja pkg-config gtk+3-devel libhandy1-devel`

## Cloning and updating submodules

> **Note**
> Kaiteki stores its translations inside **another repository** and includes them via a **submodule**, so it's important to update and initialize them before compiling.

```
git clone https://github.com/Kaiteki-Fedi/Kaiteki.git
git submodule update --init
```

## Compiling

```sh
$ melos bootstrap # Bootstrap melos and get packages
melos bootstrap
  └> /home/user/Documents/GitHub/Kaiteki

Running "flutter pub get" in workspace packages...
  ✓ kaiteki_unicode_generator
    └> packages/kaiteki_unicode_generator
  ✓ kaiteki_ui
    └> packages/kaiteki_ui
  ✓ fediverse_objects
    └> packages/fediverse_objects
  ✓ kaiteki_core
    └> packages/kaiteki_core
  ✓ kaiteki_core_backends
    └> packages/kaiteki_core_backends
  ✓ kaiteki_lints
    └> packages/kaiteki_lints
  ✓ kaiteki_l10n
    └> packages/kaiteki_l10n
  ✓ kaiteki
    └> packages/kaiteki
  > SUCCESS

Generating IntelliJ IDE files...
  > SUCCESS

 -> 8 packages bootstrapped

$ melos run build_runner
melos run build_runner
  └> melos exec -c 1 -- "dart run build_runner build --delete-conflicting-outputs"
     └> RUNNING

Select a package to run the build_runner script:

1) * [Default - Press Enter]
2) fediverse_objects
3) kaiteki
4) kaiteki_core
5) kaiteki_core_backends
6) kaiteki_unicode_generator

# press enter to build all (default)
```

## Other commands

- `flutter gen-l10n` to generate source code from localization files.
- `flutter pub upgrade` to upgrade packages to a newer minor version.

## Debugging

IDEs with official Flutter plugins are recommended. Otherwise you can still run a Flutter application with `flutter run`, and invoke actions like Hot Reload, or Hot Restart with your keyboard. Dart supports LSP, so IDEs like Kate support linting and showing problems as well.

## Things to try when a build fails

Try clearing caches and existing build files with `flutter clean`. Perhaps generated files are outdated, then you can try running `flutter pub run build_runner build --delete-conflicting-outputs`

## Official resources

- <https://docs.flutter.dev/get-started>
