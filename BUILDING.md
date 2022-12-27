# Building Kaiteki

## Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install)
  - Kaiteki is running on the Flutter **beta** branch. Prefer checking the [SDK releases page](https://docs.flutter.dev/development/tools/sdk/releases).
- A supported IDE like [Visual Studio Code](https://code.visualstudio.com/), [IntelliJ](https://www.jetbrains.com/idea/), or [Android Studio](https://developer.android.com/studio/) *(optional)*
- Build tools for your platform
  - **Android:** See Flutter "Getting Started" guide for setting up the Android SDK, otherwise download <https://developer.android.com/studio#command-line-tools-only> and set SDK path with `flutter config --android-studio-dir`
  - **Windows:** [Visual Studio](https://visualstudio.microsoft.com/downloads/) or [Build Tools for Visual Studio 2022](https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2022) with "Desktop development with C++" workload
  - **Linux:**
    - **Debian/Ubuntu:** `clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev`
    - **Void Linux:** `clang cmake ninja pkg-config gtk+3-devel`

## Cloning and updating submodules

> **Note**
> Kaiteki stores its translations inside **another repository** and includes them via a **submodule**, so it's important to update and initialize them before compiling.

```
git clone https://github.com/Kaiteki-Fedi/Kaiteki.git
git submodule update --init
```

## Compiling

```sh
$ flutter pub get # Get packages
"de": 2 untranslated message(s).
...
Running "flutter pub get" in kaiteki...
Resolving dependencies... (4.4s)
  _fe_analyzer_shared 47.0.0 (51.0.0 available)
  ...
Got dependencies!
$ flutter build apk # Check `flutter build -h` for what platforms you can compile for

💪 Building with sound null safety 💪

"de": 2 untranslated message(s).
...
Running Gradle task 'assembleDebug'...                             68.2s
✓  Built build/app/outputs/flutter-apk/app-debug.apk.  
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
