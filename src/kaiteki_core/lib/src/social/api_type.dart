import 'package:kaiteki_core/src/social/adapter.dart';
import 'package:recase/recase.dart';

import 'backends/glitch/adapter.dart';
import 'backends/mastodon/adapter.dart';
import 'backends/misskey/adapter.dart';
import 'backends/pleroma/adapter.dart';

enum ApiType<T extends BackendAdapter> {
  mastodon(MastodonAdapter.create),
  glitch(GlitchAdapter.create, probingPriority: 5),
  pleroma(PleromaAdapter.create, probingPriority: 5),
  misskey(MisskeyAdapter.create),
  akkoma(PleromaAdapter.create, probingPriority: null),
  foundkey(MisskeyAdapter.create, probingPriority: null),
  calckey(MisskeyAdapter.create, probingPriority: null);
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

  String get displayName => _displayName ?? name.titleCase;

  const ApiType(
    this._createAdapter, {
    String? displayName,
    this.hosts,
    this.probingPriority = 0,
  }) : _displayName = displayName;
}
