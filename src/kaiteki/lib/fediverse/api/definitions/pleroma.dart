import 'package:kaiteki/app_colors.dart';
import 'package:kaiteki/fediverse/api/adapters/pleroma/adapter.dart';
import 'package:kaiteki/fediverse/api/api_type.dart';
import 'package:kaiteki/fediverse/api/definitions/definitions.dart';

class PleromaApiDefinition extends ApiDefinition<PleromaAdapter> {
  @override
  String get name => 'Pleroma';

  @override
  ApiType get type => ApiType.pleroma;

  @override
  PleromaAdapter createAdapter() => PleromaAdapter();

  @override
  ApiTheme get theme {
    return const ApiTheme(
      backgroundColor: pleromaSecondary,
      primaryColor: pleromaPrimary,
      iconAssetLocation: 'assets/icons/pleroma.png',
    );
  }
}
