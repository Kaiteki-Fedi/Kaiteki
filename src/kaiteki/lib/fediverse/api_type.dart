import "package:kaiteki/fediverse/adapter.dart";
import "package:kaiteki/fediverse/api_theme.dart";
import "package:kaiteki/fediverse/backends/glitch/adapter.dart";
import "package:kaiteki/fediverse/backends/mastodon/adapter.dart";
import "package:kaiteki/fediverse/backends/misskey/adapter.dart";
import "package:kaiteki/fediverse/backends/pleroma/adapter.dart";
import "package:kaiteki/fediverse/backends/twitter/v1/adapter.dart";
import "package:kaiteki/fediverse/backends/twitter/v2/adapter.dart";

Future<TwitterAdapter> _instantiateTwitterV2(String _) async =>
    TwitterAdapter();
Future<OldTwitterAdapter> _instantiateTwitterV1(String _) async =>
    OldTwitterAdapter();

enum ApiType<T extends BackendAdapter> {
  mastodon(MastodonAdapter.create, theme: mastodonTheme),
  glitch(GlitchAdapter.create, theme: mastodonTheme),
  pleroma(PleromaAdapter.create, theme: pleromaTheme),
  misskey(MisskeyAdapter.create, theme: misskeyTheme),
  akkoma(PleromaAdapter.create, theme: akkomaTheme, disfavorsProbing: true),
  foundkey(MisskeyAdapter.create, theme: foundKeyTheme, disfavorsProbing: true),
  calckey(MisskeyAdapter.create, theme: calckeyTheme, disfavorsProbing: true),
  // TODO(Craftplacer): I'm too lazy, sowwy
  // goToSocial(MastodonAdapter.create, theme: goToSocialTheme),
  twitter(_instantiateTwitterV2, theme: twitterTheme, hosts: ["twitter.com"]),
  twitterV1(
    _instantiateTwitterV1,
    theme: twitterTheme,
    hosts: ["twitter.com"],
    disfavorsProbing: true,
  );

  final String? _displayName;
  final Future<T> Function(String instance) createAdapter;
  final ApiTheme theme;
  final List<String>? hosts;
  final bool disfavorsProbing;
  Type get adapterType => T;

  String get displayName {
    return _displayName ?? name[0].toUpperCase() + name.substring(1);
  }

  const ApiType(
    this.createAdapter, {
    String? displayName,
    required this.theme,
    this.hosts,
    this.disfavorsProbing = false,
  }) : _displayName = displayName;

  bool isType(BackendAdapter adapter) => adapter.runtimeType == adapterType;
}
