import 'package:kaiteki/fediverse/api/adapters/mastodon/adapter.dart';
import 'package:kaiteki/fediverse/api/api_type.dart';
import 'package:kaiteki/fediverse/api/definitions/definitions.dart';
import 'package:kaiteki/app_colors.dart';

class MastodonApiDefinition extends ApiDefinition<MastodonAdapter> {
  @override
  createAdapter() => MastodonAdapter();

  @override
  String get name => 'Mastodon';

  @override
  ApiType get type => ApiType.Mastodon;

  @override
  ApiTheme get theme {
    return ApiTheme(
      backgroundColor: AppColors.mastodonSecondary,
      primaryColor: AppColors.mastodonPrimary,
      iconAssetLocation: 'assets/icons/mastodon.png',
    );
  }
}
