# Kaiteki

[![Translation status](http://wl.craftplacer.moe/widgets/kaiteki/-/app/svg-badge.svg)](http://wl.craftplacer.moe/engage/kaiteki/)

<img align="right" src="assets/icons/windows/kaiteki.png" width=100>

A [快適 (kaiteki)](http://takoboto.jp/?w=1200120) Fediverse client for microblogging instances, made with [Flutter](https://flutter.dev/) and [Dart](https://dart.dev/).

Currently, Kaiteki is still in a **proof-of-concept/alpha stage**, with simple Mastodon/Pleroma and Misskey support, future backends could follow. See ["What's working, what's missing?"](#whats-working-whats-missing).

## Screenshots (outdated)

| Welcome page | Pleroma timeline | Misskey timeline | About page |
| - | - | - | - |
| ![](assets/screenshots/welcome.jpg) | ![](assets/screenshots/pleroma-feed.jpg) | ![](assets/screenshots/misskey-feed.jpg) | ![](assets/screenshots/about.jpg) |

## Platforms & Releases

If you want to try out Kaiteki, there are automatic builds available for use.

<table>
    <tr>
        <th></th>
        <th>Web<br>(recommended)</th>
        <th>Windows</th>
        <th>Linux</th>
        <th>Android</th>
        <th>macOS</th>
        <th>iOS</th>
    </tr>
    <tr>
        <th>Build status</th>
        <td><img src="https://img.shields.io/github/workflow/status/Craftplacer/kaiteki/Web"></td>
        <td><img src="https://img.shields.io/github/workflow/status/Craftplacer/kaiteki/Windows"></td>
        <td><img src="https://img.shields.io/github/workflow/status/Craftplacer/kaiteki/Linux"></td>
        <td rowspan=3>No CI/CD available yet.<br><a href="https://github.com/Craftplacer/kaiteki/issues/2">Help us!</a></td>
        <td colspan=2 rowspan=3>Not supported.</td>
    </tr>
    <tr>
        <th>Binaries</th>
        <td rowspan=2><a href="https://kaiteki.craftplacer.moe/">Visit web version</a></td>
        <td><a href="https://nightly.link/Craftplacer/Kaiteki/workflows/windows/master/windows.zip">Download latest binaries</a></td>
        <td><a href="https://nightly.link/Craftplacer/Kaiteki/workflows/linux/master/linux.zip">Download latest binaries</a></td>
    </tr>
    <tr>
        <th>Packages / Installers</th>
        <td>No reliable packaging yet.<br><a href="https://github.com/Craftplacer/Kaiteki/issues/63">Help us!</a></td>
        <td>No reliable packaging yet.<br><a href="https://github.com/Craftplacer/Kaiteki/issues/62">Help us!</a></td>
    </tr>
</table>


## What's working, what's missing?

Currently, Kaiteki only allows viewing timelines, making text posts and viewing users.

Most important API calls for Misskey, Mastodon/Pleroma are already implemented but need a UI implementation.

Other features that are missing are extensive settings, unit tests, and many other things. **If you'd like to contribute, feel free to do so.**

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
