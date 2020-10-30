# ![Kaiteki](assets/readme-logo.png)

![Build and deploy](https://github.com/Craftplacer/kaiteki/workflows/Build%20and%20deploy/badge.svg)
![Total downloads](https://img.shields.io/github/downloads/Craftplacer/kaiteki/total)

A Fediverse client for micro-blogging instances written in Flutter/Dart.

Currently Kaiteki has simple Mastodon/Pleroma and Misskey support, future backends could follow.

I'm happy about any feedback or contribution you have.

## Screenshots

| Welcome page | Login page | Feed of a Pleroma instance | Feed of a Misskey instance | About page |
| - | - | - | - | - |
| ![](assets/screenshots/welcome.jpg) | ![](assets/screenshots/login.jpg) | ![](assets/screenshots/pleroma-feed.jpg) | ![](assets/screenshots/misskey-feed.jpg) | ![](assets/screenshots/about.jpg) |

## Download and use Kaiteki

If you want to try out Kaiteki, there are automatic releases available for use.

Please still note, that **Kaiteki is still in development**.
Unpolished code, bugs and missing features might be present in these builds, so think twice when creating issues.

[![Visit web version](https://img.shields.io/badge/-Download%20for%20Windows%20-blue)][1]
[![Download latest Linux build](https://img.shields.io/badge/-Download%20for%20Linux%20-red)][2]
[![View other builds](https://img.shields.io/badge/-Other%20builds%20-gray)][3]

[1]: https://craftplacer.github.io/kaiteki/
[2]: https://github.com/Craftplacer/kaiteki/releases/latest/download/linux.zip
[3]: https://github.com/Craftplacer/kaiteki/releases "Releases page"


### Why isn't my platform available

Packaged Linux releases and Windows builds are yet to be integrated into the GitHub build and deploy workflow.

Apple based platforms won't get any support, until one user will offer building and maintaining those builds.


## Compiling Kaiteki

Depending on your platform you might have to take extra steps.
See [this page for steps on compiling for desktop](https://flutter.dev/desktop#requirements), and [this page for steps on compiling for web](https://flutter.dev/docs/get-started/web).

```sh
flutter upgrade # upgrade flutter to its latest version
flutter pub get # get packages

# run (debug)
flutter run
# or build (release)
flutter build apk
flutter build windows
flutter build linux
flutter build web
# and so on...
```
