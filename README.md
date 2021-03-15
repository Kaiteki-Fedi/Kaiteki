# Kaiteki

<img align="right" src="assets/icons/windows/kaiteki.png" width=100>

A [快適 (kaiteki)](http://takoboto.jp/?w=1200120) Fediverse client for microblogging instances, made with [Flutter](https://flutter.dev/) + [Dart](https://dart.dev/).

Currently Kaiteki is still in a proof-of-concept/alpha stage, with simple Mastodon/Pleroma and Misskey support, future backends could follow. See "What's working, what's missing?".

## Aims and goals of this project

Kaiteki's mission is to support every Fediverse backend, OS platform and end user.

Kaiteki is built with Flutter, which has seen major progress in shipping to a wide range of devices, from mobile to desktop and the web.

The development of Kaiteki tries to support major (and in future minor) Fediverse backends, while not compromising on features.

We'll stay neutral and objective to every use case and view of every end user and try to give them the most comfortable and customizable Fediverse client.

Kaiteki tries to be community-driven with polls and opinions fetched from its creator, while also privacy-respecting. This means to also reject proprietary services and prefer everything to be transparent. An example of this is the rejection of Google's Firebase Cloud Messaging (FCM/GCM, which is being needlessly shoved in everyone's face by everyone else) in favor of a Flutter package called [`flutter_local_notifications`](https://pub.dev/packages/flutter_local_notifications). Another example is user's voicing disagreement over using error analytics like [Sentry](http://sentry.io/), which has been noted and will be avoided.

## Screenshots (outdated)

| Welcome page | Login page | Pleroma timeline | Misskey timeline | About page |
| - | - | - | - | - |
| ![](assets/screenshots/welcome.jpg) | ![](assets/screenshots/login.jpg) | ![](assets/screenshots/pleroma-feed.jpg) | ![](assets/screenshots/misskey-feed.jpg) | ![](assets/screenshots/about.jpg) |

## Platforms & Releases<>

If you want to try out Kaiteki, there are automatic builds available for use.

Please still note, that **Kaiteki is still in development**. I don't take gurantee that everything works.

| Platform | Build status | Link |
| - | - | - |
| Web | ![](https://github.com/Craftplacer/kaiteki/workflows/Build%20and%20deploy%20to%20Web/badge.svg) | [Visit web version](https://craftplacer.github.io/kaiteki/) |
| Windows | ![](https://github.com/Craftplacer/kaiteki/actions/workflows/windows.yml/badge.svg) | [Check build artifacts](https://github.com/Craftplacer/kaiteki/actions/workflows/windows.yml) |
| Linux | ![](https://github.com/Craftplacer/kaiteki/actions/workflows/linux.yml/badge.svg) | [Check build artifacts](https://github.com/Craftplacer/kaiteki/actions/workflows/linux.yml) |
| Android | No CI/CD available yet ([See issue #2](https://github.com/Craftplacer/kaiteki/issues/2)) |
| iOS | Not supported | |
| macOS | Not supported | |

### I'm thinking about packaging Kaiteki for my Linux, GNU/Linux, *nix distrobution

That's great! Before anything though, **avoid trying to package Kaiteki if your package repository requires self-compiling**.

While Kaiteki's source code is static and transparent, the Dart/Flutter SDK is not. I have heard several stories about it being difficult near to impossible to compile on your own (because it's self-updating, etc).

My hands are bound on that one and you have to accept pre-made binaries, unless you manually compile. Sorry :(

## What's working, what's missing?

Currently Kaiteki only allows viewing timelines. Estimated, most important API calls for Misskey, Pleroma/Mastodon are already implemented, but lack proper internal adapter design, alongside their user interface.

## Contributing

I'm happy about any feedback or contribution you have.

Since I am inexperienced with large scale projects, I have nothing against contributors, PRs, questions and anything in-between.

If you have questions you can reach me anywhere on [my contact page](https://craftplacer.github.io/about) (preferrably over email), you can also comment under issues that you want to get assigned to and want to work on.


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
