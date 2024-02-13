import 'dart:async';

import 'package:kaiteki_core/social.dart';
import 'package:kaiteki_core_backends/pleroma.dart';
import 'package:kaiteki_core_backends/misskey.dart';
import 'package:kaiteki_core_backends/glitch.dart';
import 'package:kaiteki_core_backends/tumblr.dart';

FutureOr<TumblrAdapter> _instantiateTumblr(String _) => TumblrAdapter();

enum BackendType<T extends BackendAdapter> {
  mastodon(MastodonAdapter.create),
  glitch(GlitchAdapter.create, probingPriority: 5),
  pleroma(PleromaAdapter.create, probingPriority: 5),
  misskey(MisskeyAdapter.create),
  akkoma(PleromaAdapter.create, probingPriority: null),
  foundkey(MisskeyAdapter.create, probingPriority: null),
  calckey(MisskeyAdapter.create, probingPriority: null),
  tumblr(_instantiateTumblr, hosts: ["tumblr.com"]);

  final FutureOr<T> Function(String instance) _createAdapter;
  final List<String>? hosts;

  /// Which priority each API type has when probing the instance.
  ///
  /// If set to `null`, the probing is disabled.
  final int? probingPriority;

  Type get adapterType => T;

  FutureOr<T> createAdapter(String instance) => _createAdapter(instance);

  const BackendType(
    this._createAdapter, {
    this.hosts,
    this.probingPriority = 0,
  });
}
