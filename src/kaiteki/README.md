# ![Kaiteki](assets/readme-banner.svg)

[![Build status](https://img.shields.io/github/actions/workflow/status/Kaiteki-Fedi/Kaiteki/ci.yml?branch=master)](https://github.com/Kaiteki-Fedi/Kaiteki/actions/workflows/ci.yml) [![CodeFactor](https://www.codefactor.io/repository/github/kaiteki-fedi/kaiteki/badge)](https://www.codefactor.io/repository/github/kaiteki-fedi/kaiteki) [![codecov](https://codecov.io/gh/Kaiteki-Fedi/Kaiteki/branch/master/graph/badge.svg?token=AFWBGW0XE4)](https://codecov.io/gh/Kaiteki-Fedi/Kaiteki)
[![Translation status](https://hosted.weblate.org/widgets/kaiteki/-/kaiteki/svg-badge.svg)](https://hosted.weblate.org/engage/kaiteki/)

A [快適 (kaiteki)](http://takoboto.jp/?w=1200120) Fediverse client for microblogging instances, made with [Flutter](https://flutter.dev/) and [Dart](https://dart.dev/).

Currently, Kaiteki is still in a **proof-of-concept/alpha stage**, with simple Mastodon/Pleroma and Misskey support, future backends could follow. See ["What's working, what's missing?"](#whats-working-whats-missing).

## Screenshots

<table>
    <td><img src="assets/screenshots/misskey-feed-phone.jpg" width="110" alt="Screenshot of a Misskey feed inside Kaiteki on a phone"></td>
    <td><img src="assets/screenshots/pleroma-user-tablet.jpg" width="400" alt="Screenshot of an user inside Kaiteki on a tablet"></td>
</table>

## Platforms & Releases

Kaiteki is available for Web, Windows, Linux and Android. Check out [the releases page](https://github.com/Kaiteki-Fedi/Kaiteki/releases) for automatic builds.

## What's working, what's missing?

Currently, Kaiteki only allows viewing timelines, making text posts and viewing users.

Most important API calls for Misskey, Mastodon/Pleroma are already implemented but need a UI implementation.

Other features that are missing are extensive settings, unit tests, and many other things. **If you'd like to contribute, feel free to do so.**

## Compiling Kaiteki

Check [BUILDING.md](/BUILDING.md).
