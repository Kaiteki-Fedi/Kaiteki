import "package:collection/collection.dart";
import "package:flutter/material.dart" show IconData, Icons;
import "package:html/parser.dart" as html;
import "package:simple_icons/simple_icons.dart";

final _websiteRegex = RegExp(
  r"^(home|web(bed)?)(\s?(site|page))?$",
  caseSensitive: false,
);

final _telegramRegex = RegExp(r"^@?([a-z0-9_]{5,})$", caseSensitive: false);

typedef _KnownService = (IconData icon, String name);

typedef ProfileLink = (IconData icon, String label, Uri uri);

final _knownServices = <List<String>, _KnownService>{
  ["youtube.com", "youtu.be"]: (SimpleIcons.youtube, "YouTube"),
  ["twitter.com", "x.com", "nitter.net"]: (SimpleIcons.twitter, "Twitter"),
  ["github.com"]: (SimpleIcons.github, "GitHub"),
  ["gitlab.com"]: (SimpleIcons.gitlab, "GitLab"),
  ["mastodon.social"]: (SimpleIcons.mastodon, "Mastodon"),
  ["pixiv.net"]: (SimpleIcons.pixiv, "Pixiv"),
  ["twitch.tv"]: (SimpleIcons.twitch, "Twitch"),
  ["soundcloud.com"]: (SimpleIcons.soundcloud, "SoundCloud"),
  ["steamcommunity.com"]: (SimpleIcons.steam, "Steam"),
  ["patreon.com"]: (SimpleIcons.patreon, "Patreon"),
  ["deviantart.com"]: (SimpleIcons.deviantart, "DeviantArt"),
  ["tumblr.com"]: (SimpleIcons.tumblr, "Tumblr"),
  ["reddit.com"]: (SimpleIcons.reddit, "Reddit"),
  ["instagram.com"]: (SimpleIcons.instagram, "Instagram"),
  ["facebook.com"]: (SimpleIcons.facebook, "Facebook"),
  ["discord.com", "discord.gg"]: (SimpleIcons.discord, "Discord"),
  ["tiktok.com"]: (SimpleIcons.tiktok, "TikTok"),
  ["t.me"]: (SimpleIcons.telegram, "Telegram"),
  ["matrix.to"]: (SimpleIcons.matrix, "Matrix"),
  ["paypal.me"]: (SimpleIcons.paypal, "PayPal"),
  ["ko-fi.com"]: (SimpleIcons.kofi, "Ko-fi"),
};

final _knownSchemes = <List<String>, _KnownService>{
  ["mailto"]: (Icons.email_rounded, "Email"),
  ["irc"]: (Icons.tag_rounded, "IRC"),
  ["xmpp"]: (SimpleIcons.xmpp, "XMPP"),
};

(
  List<MapEntry<String, String>> fields,
  List<ProfileLink> links,
) extractLinksFromFields(List<MapEntry<String, String>> fields) {
  final links = <ProfileLink>[];
  final newFields = <MapEntry<String, String>>[];

  /// Tries to extract the URL from an anchor tag, if the field may be
  /// HTML-formatted.
  String normalizeValue(String input) {
    final fragment = html.parseFragment(input);

    final anchor =
        fragment.children.singleWhereOrNull((e) => e.localName == "a");
    if (anchor == null) return input;

    final href = anchor.attributes["href"];
    if (href == null) return input;

    final uri = Uri.tryParse(href);
    if (uri == null) return input;

    return uri.toString();
  }

  for (final field in fields) {
    final value = normalizeValue(field.value);
    final link = determineLink(field.key, value);
    if (link != null) {
      links.add(link);
    } else {
      newFields.add(field);
    }
  }

  return (newFields, links);
}

ProfileLink? determineLink(String key, String value) {
  final normalizedKey = key.trim().toLowerCase();

  var url = Uri.tryParse(value);

  if (url != null) {
    if (url.host.toLowerCase().startsWith("www.")) {
      url = url.replace(host: url.host.substring(4));
    }

    final service = _detectService(url);

    if (service != null) return (service.$1, key, url);

    if (_websiteRegex.hasMatch(normalizedKey)) {
      return (Icons.language_rounded, key, url);
    }
  }

  const parsers = [_parseTelegram];

  for (final parser in parsers) {
    final link = parser(key, value);
    if (link != null) return (link.$1, key, link.$2);
  }

  return null;
}

(IconData, Uri)? _parseTelegram(String key, String value) {
  if (key != "telegram" || key != "tg") return null;

  final match = _telegramRegex.firstMatch(value);

  if (match == null) return null;

  final username = match.group(1);
  return (
    SimpleIcons.telegram,
    Uri.parse("https://t.me/$username"),
  );
}

_KnownService? _detectService(Uri url) {
  late _KnownService? service;

  final normalizedScheme = url.scheme.toLowerCase();
  service = _knownSchemes.entries
      .firstWhereOrNull((entry) => entry.key.contains(normalizedScheme))
      ?.value;

  if (service != null) return service;

  final normalizedHost = url.host.toLowerCase();
  return _knownServices.entries
      .firstWhereOrNull((entry) => entry.key.contains(normalizedHost))
      ?.value;
}
