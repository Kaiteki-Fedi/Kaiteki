import 'package:kaiteki/app_colors.dart';
import 'package:kaiteki/fediverse/api/adapters/mastodon/adapter.dart';
import 'package:kaiteki/fediverse/api/api_type.dart';
import 'package:kaiteki/fediverse/api/definitions/definitions.dart';

class MastodonApiDefinition extends ApiDefinition<MastodonAdapter> {
  @override
  MastodonAdapter createAdapter() => MastodonAdapter();

  @override
  String get name => 'Mastodon';

  @override
  ApiType get type => ApiType.mastodon;

  @override
  ApiTheme get theme {
    return const ApiTheme(
      backgroundColor: mastodonSecondary,
      primaryColor: mastodonPrimary,
      iconAssetLocation: 'assets/icons/mastodon.png',
    );
  }
}
