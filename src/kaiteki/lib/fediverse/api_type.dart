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

enum ApiType {
  mastodon(
    createAdapter: MastodonAdapter.create,
    theme: mastodonTheme,
    adapterType: MastodonAdapter,
  ),
  glitch(
    createAdapter: GlitchAdapter.create,
    theme: mastodonTheme,
    adapterType: GlitchAdapter,
  ),
  pleroma(
    createAdapter: PleromaAdapter.create,
    theme: pleromaTheme,
    adapterType: PleromaAdapter,
  ),
  misskey(
    createAdapter: MisskeyAdapter.create,
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
  );

  final String? _displayName;
  final Future<BackendAdapter> Function(String instance) createAdapter;
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
    // ignore: unused_element, used for Twitter later on
    this.hosts,
  }) : _displayName = displayName;

  bool isType(BackendAdapter adapter) => adapter.runtimeType == adapterType;
}
