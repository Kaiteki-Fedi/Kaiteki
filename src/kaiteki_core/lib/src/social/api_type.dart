import 'package:kaiteki_core/src/social/adapter.dart';
import 'package:kaiteki_core/src/social/backends/glitch/adapter.dart';
import 'package:kaiteki_core/src/social/backends/mastodon/adapter.dart';
import 'package:kaiteki_core/src/social/backends/misskey/adapter.dart';
import 'package:kaiteki_core/src/social/backends/pleroma/adapter.dart';
import 'package:kaiteki_core/src/social/backends/tumblr/adapter.dart';

Future<TumblrAdapter> _instantiateTumblr(ApiType _, String __) async {
  return TumblrAdapter();
}

enum ApiType<T extends BackendAdapter> {
  mastodon(MastodonAdapter.create),
  glitch(GlitchAdapter.create, probingPriority: 5),
  pleroma(PleromaAdapter.create, probingPriority: 5),
  misskey(MisskeyAdapter.create),
  akkoma(PleromaAdapter.create, probingPriority: null),
  foundkey(MisskeyAdapter.create, probingPriority: null),
  calckey(MisskeyAdapter.create, probingPriority: null),
  tumblr(_instantiateTumblr, hosts: ['tumblr.com']);
  // TODO(Craftplacer): I'm too lazy, sowwy
  // goToSocial(MastodonAdapter.create, theme: goToSocialTheme),

  final String? _displayName;
  final Future<T> Function(ApiType type, String instance) _createAdapter;
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
    this._createAdapter, {
    String? displayName,
    this.hosts,
    this.probingPriority = 0,
  }) : _displayName = displayName;
}
