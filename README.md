# Kaiteki

<img align="right" src="assets/icons/windows/kaiteki.png" width=100>

A [快適 (kaiteki)](http://takoboto.jp/?w=1200120) Fediverse client for microblogging instances, made with [Flutter](https://flutter.dev/) and [Dart](https://dart.dev/).

Currently Kaiteki is still in a **proof-of-concept/alpha stage**, with simple Mastodon/Pleroma and Misskey support, future backends could follow. See ["What's working, what's missing?"](#whats-working-whats-missing).

## Screenshots (outdated)

| Welcome page | Pleroma timeline | Misskey timeline | About page |
| - | - | - | - |
| ![](assets/screenshots/welcome.jpg) | ![](assets/screenshots/pleroma-feed.jpg) | ![](assets/screenshots/misskey-feed.jpg) | ![](assets/screenshots/about.jpg) |

## Platforms & Releases

If you want to try out Kaiteki, there are automatic builds available for use.

| Platform | Build status | Link |
| -------- | ------------ | ---- |
| Web      | ![](https://img.shields.io/github/workflow/status/Craftplacer/kaiteki/Web) | [Visit web version](https://craftplacer.github.io/kaiteki/) |
| Windows  | ![](https://img.shields.io/github/workflow/status/Craftplacer/kaiteki/Windows) | [Check build artifacts](https://github.com/Craftplacer/kaiteki/actions/workflows/windows.yml) |
| Linux    | ![](https://img.shields.io/github/workflow/status/Craftplacer/kaiteki/Linux) | [Check build artifacts](https://github.com/Craftplacer/kaiteki/actions/workflows/linux.yml) |
| Android  | No CI/CD available yet ([See issue #2](https://github.com/Craftplacer/kaiteki/issues/2)) |
| iOS      | Not supported | |
| macOS    | Not supported | |

## What's working, what's missing?

Currently Kaiteki only allows viewing timelines. Estimated, most important API calls for Misskey, Pleroma/Mastodon are already implemented, but lack proper internal adapter design, alongside their user interface.

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
