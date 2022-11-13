import 'package:kaiteki/fediverse/adapter.dart';
import 'package:kaiteki/fediverse/api_theme.dart';
import 'package:kaiteki/fediverse/backends/mastodon/adapter.dart';
import 'package:kaiteki/fediverse/backends/misskey/adapter.dart';
import 'package:kaiteki/fediverse/backends/pleroma/adapter.dart';
import 'package:kaiteki/fediverse/backends/twitter/v1/adapter.dart';
import 'package:kaiteki/fediverse/backends/twitter/v2/adapter.dart';

enum ApiType {
  mastodon(createAdapter: MastodonAdapter.new, theme: mastodonTheme),
  pleroma(createAdapter: PleromaAdapter.new, theme: pleromaTheme),
  misskey(createAdapter: MisskeyAdapter.new, theme: misskeyTheme),
  twitter(
    createAdapter: TwitterAdapter.new,
    theme: twitterTheme,
    hosts: ["twitter.com"],
  ),
  twitterV1(
    createAdapter: OldTwitterAdapter.new,
    theme: twitterTheme,
    hosts: ["twitter.com"],
  );

  final String? _displayName;
  final FediverseAdapter Function(String instance) createAdapter;
  final ApiTheme theme;
  final List<String>? hosts;

  String get displayName {
    return _displayName ?? name[0].toUpperCase() + name.substring(1);
  }

  const ApiType({
    String? displayName,
    required this.createAdapter,
    required this.theme,
    // ignore: unused_element, used for Twitter later on
    this.hosts,
  }) : _displayName = displayName;
}
