import 'package:kaiteki/adapters/fediverse_adapter.dart';
import 'package:kaiteki/model/responses/adapter_response.dart';

class LoginResponse<A extends FediverseAdapter> extends AdapterResponse {
  /// The account that is being tried to log into is requesting additional
  /// multi-factor-authentication.
  bool mfaRequested = false;

  String reason;

  LoginResponse.successful(A source) : super(source);

  LoginResponse.mfaRequired(A source) : super(source) {
    mfaRequested = true;
  }

  LoginResponse.failed(A source, this.reason) : super(source) {
    assert(this.reason.isNotEmpty);
  }
}