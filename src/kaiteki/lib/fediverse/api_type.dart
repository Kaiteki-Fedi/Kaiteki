import 'package:kaiteki/fediverse/adapter.dart';
import 'package:kaiteki/fediverse/api_theme.dart';
import 'package:kaiteki/fediverse/backends/mastodon/adapter.dart';
import 'package:kaiteki/fediverse/backends/misskey/adapter.dart';
import 'package:kaiteki/fediverse/backends/pleroma/adapter.dart';

enum ApiType {
  mastodon(createAdapter: MastodonAdapter.new, theme: mastodonTheme),
  pleroma(createAdapter: PleromaAdapter.new, theme: pleromaTheme),
  misskey(createAdapter: MisskeyAdapter.new, theme: misskeyTheme);

  final String? _displayName;
  final FediverseAdapter Function() createAdapter;
  final ApiTheme theme;

  String get displayName {
    return _displayName ?? name[0].toUpperCase() + name.substring(1);
  }

  const ApiType({
    String? displayName,
    required this.createAdapter,
    required this.theme,
  }) : _displayName = displayName;
}
