import "package:kaiteki/fediverse/adapter.dart";
import "package:kaiteki/fediverse/api_theme.dart";
import "package:kaiteki/fediverse/backends/glitch/adapter.dart";
import "package:kaiteki/fediverse/backends/mastodon/adapter.dart";
import "package:kaiteki/fediverse/backends/misskey/adapter.dart";
import "package:kaiteki/fediverse/backends/pleroma/adapter.dart";
import "package:kaiteki/fediverse/backends/twitter/v1/adapter.dart";
import "package:kaiteki/fediverse/backends/twitter/v2/adapter.dart";

Future<TwitterAdapter> _instantiateTwitterV2(ApiType _, String __) async =>
    TwitterAdapter();
Future<OldTwitterAdapter> _instantiateTwitterV1(ApiType _, String __) async =>
    OldTwitterAdapter();

enum ApiType<T extends BackendAdapter> {
  mastodon(MastodonAdapter.create, mastodonTheme),
  glitch(GlitchAdapter.create, mastodonTheme, probingPriority: 5),
  pleroma(PleromaAdapter.create, pleromaTheme, probingPriority: 5),
  misskey(MisskeyAdapter.create, misskeyTheme),
  akkoma(PleromaAdapter.create, akkomaTheme, probingPriority: null),
  foundkey(MisskeyAdapter.create, foundKeyTheme, probingPriority: null),
  calckey(MisskeyAdapter.create, calckeyTheme, probingPriority: null),
  twitter(_instantiateTwitterV2, twitterTheme, hosts: ["twitter.com"]),
  twitterV1(
    _instantiateTwitterV1,
    twitterTheme,
    hosts: ["twitter.com"],
    probingPriority: null,
  );
  // TODO(Craftplacer): I'm too lazy, sowwy
  // goToSocial(MastodonAdapter.create, theme: goToSocialTheme),

  final String? _displayName;
  final Future<T> Function(ApiType type, String instance) _createAdapter;
  final ApiTheme theme;
  final List<String>? hosts;

  /// Which priority each API type has when probing the instance.
  ///
  /// If set to `null`, the probing is disabled.
  final int? probingPriority;
  Type get adapterType => T;

  Future<T> createAdapter(String instance) => _createAdapter(this, instance);

  String get displayName {
    return _displayName ?? name[0].toUpperCase() + name.substring(1);
  }

  const ApiType(
    this._createAdapter,
    this.theme, {
    String? displayName,
    this.hosts,
    this.probingPriority = 0,
  }) : _displayName = displayName;
}
