import "package:kaiteki/fediverse/adapter.dart";
import "package:kaiteki/fediverse/api_theme.dart";
import "package:kaiteki/fediverse/backends/mastodon/adapter.dart";
import "package:kaiteki/fediverse/backends/misskey/adapter.dart";
import "package:kaiteki/fediverse/backends/pleroma/adapter.dart";
import "package:kaiteki/fediverse/backends/tumblr/adapter.dart";
import "package:kaiteki/fediverse/backends/twitter/v1/adapter.dart";
import "package:kaiteki/fediverse/backends/twitter/v2/adapter.dart";

TwitterAdapter _instantiateTwitterV2(String _) => TwitterAdapter();
OldTwitterAdapter _instantiateTwitterV1(String _) => OldTwitterAdapter();
TumblrAdapter _instantiateTumblr(String _) => TumblrAdapter();

enum ApiType {
  mastodon(
    createAdapter: MastodonAdapter.new,
    theme: mastodonTheme,
    adapterType: MastodonAdapter,
  ),
  pleroma(
    createAdapter: PleromaAdapter.new,
    theme: pleromaTheme,
    adapterType: PleromaAdapter,
  ),
  misskey(
    createAdapter: MisskeyAdapter.new,
    theme: misskeyTheme,
    adapterType: MisskeyAdapter,
  ),
  twitter(
    createAdapter: _instantiateTwitterV2,
    theme: twitterTheme,
    hosts: ["twitter.com"],
    adapterType: TwitterAdapter,
  ),
  twitterV1(
    createAdapter: _instantiateTwitterV1,
    theme: twitterTheme,
    hosts: ["twitter.com"],
    adapterType: OldTwitterAdapter,
  ),
  tumblr(
    displayName: "Tumblr",
    createAdapter: _instantiateTumblr,
    theme: tumblrTheme,
    adapterType: TumblrAdapter,
  );

  final String? _displayName;
  final BackendAdapter Function(String instance) createAdapter;
  final ApiTheme theme;
  final List<String>? hosts;
  final Type adapterType;

  String get displayName {
    return _displayName ?? name[0].toUpperCase() + name.substring(1);
  }

  const ApiType({
    String? displayName,
    required this.createAdapter,
    required this.theme,
    required this.adapterType,
    this.hosts,
  }) : _displayName = displayName;

  bool isType(BackendAdapter adapter) => adapter.runtimeType == adapterType;
}
