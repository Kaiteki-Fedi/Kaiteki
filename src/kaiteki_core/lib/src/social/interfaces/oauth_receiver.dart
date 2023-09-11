import 'login_support.dart';

abstract class OAuthReceiver {
  /// Handles an OAuth callback.
  Future<LoginResult> handleOAuth(
    Map<String, String> query,
    Map<String, String>? extra,
  );
}
