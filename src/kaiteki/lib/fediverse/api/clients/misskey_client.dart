import 'package:fediverse_objects/misskey.dart' as misskey;
import 'package:kaiteki/fediverse/api/api_type.dart';
import 'package:kaiteki/fediverse/api/clients/fediverse_client_base.dart';
import 'package:kaiteki/fediverse/api/exceptions/misskey_exception.dart';
import 'package:kaiteki/fediverse/api/http/response.dart';
import 'package:kaiteki/fediverse/api/requests/misskey/sign_in.dart';
import 'package:kaiteki/fediverse/api/requests/misskey/timeline.dart';
import 'package:kaiteki/fediverse/api/responses/misskey/create_app_response.dart';
import 'package:kaiteki/fediverse/api/responses/misskey/generate_session_response.dart';
import 'package:kaiteki/fediverse/api/responses/misskey/signin_response.dart';
import 'package:kaiteki/fediverse/api/responses/misskey/userkey_response.dart';
import 'package:kaiteki/logger.dart';
import 'package:kaiteki/model/auth/account_secret.dart';
import 'package:kaiteki/model/auth/authentication_data.dart';
import 'package:kaiteki/model/auth/client_secret.dart';
import 'package:kaiteki/model/http_method.dart';

class MisskeyClient extends FediverseClientBase<MisskeyAuthenticationData> {
  @override
  ApiType get type => ApiType.misskey;

  static final _logger = getLogger("misskey.MisskeyClient");

  Future<MisskeyCreateAppResponse> createApp(
    String name,
    String description,
    List<String> permissions, {
    String? callbackUrl,
  }) async {
    return await sendJsonRequest(
      HttpMethod.post,
      "api/app/create",
      (json) => MisskeyCreateAppResponse.fromJson(json),
      body: {
        "name": name,
        "description": description,
        "permission": permissions,
        "callbackUrl": callbackUrl
      },
    );
  }

  Future<misskey.Note> createNote(
    String visibility, {
    List<String>? visibleUserIds,
    String? text,
    String? cw,
    String? replyId,
  }) async {
    // FIXME: Properly parse Misskey create note response
    return await sendJsonRequest(
      HttpMethod.post,
      "api/notes/create",
      (json) => misskey.Note.fromJson(json),
      body: <String, dynamic>{
        "visibility": visibility,
        "visibleUserIds": visibleUserIds ?? [],
        if (text != null) "text": text,
        if (cw != null) "cw": cw,
        if (replyId != null) "replyId": replyId,
      },
    );
  }

  Future<MisskeyGenerateSessionResponse> generateSession(
    String appSecret,
  ) async {
    return await sendJsonRequest(
      HttpMethod.post,
      "/api/auth/session/generate",
      (j) => MisskeyGenerateSessionResponse.fromJson(j),
      body: {"appSecret": appSecret},
    );
  }

  Future<misskey.Page> getPage(String username, String name) async {
    return await sendJsonRequest(
      HttpMethod.post,
      "api/pages/show",
      (json) => misskey.Page.fromJson(json),
      body: {
        "username": username,
        "name": name,
      },
    );
  }

  Future<MisskeyUserkeyResponse> userkey(String appSecret, String token) async {
    return await sendJsonRequest(
      HttpMethod.post,
      "api/auth/session/userkey",
      (json) => MisskeyUserkeyResponse.fromJson(json),
      body: {"appSecret": appSecret, "token": token},
    );
  }

  Future<misskey.User?> showUser(String userId) async {
    return await sendJsonRequest(
      HttpMethod.post,
      "api/users/show",
      (json) => misskey.User.fromJson(json),
      body: {"userId": userId},
    );
  }

  Future<misskey.User> showUserByName(
    String username, [
    String? instance,
  ]) async {
    var body = {"username": username};

    if (instance != null) body["instance"] = instance;

    return await sendJsonRequest(
      HttpMethod.post,
      "api/users/show",
      (json) => misskey.User.fromJson(json),
    );
  }

  Future<Iterable<misskey.Note>> showUserNotes(
    String userId,
    bool excludeNsfw,
    Iterable<String> fileTypes,
  ) async {
    return await sendJsonRequestMultiple(
      HttpMethod.post,
      "api/users/notes",
      (json) => misskey.Note.fromJson(json),
      body: {
        "userId": userId,
        "fileType": fileTypes,
        "excludeNsfw": excludeNsfw,
      },
    );
  }

  Future<MisskeySignInResponse> signIn(MisskeySignInRequest request) async {
    return await sendJsonRequest(
      HttpMethod.post,
      "api/signin",
      (json) => MisskeySignInResponse.fromJson(json),
      body: request,
    );
  }

  Future<Iterable<misskey.Note>> getTimeline(
    MisskeyTimelineRequest request,
  ) async {
    return await sendJsonRequestMultiple(
      HttpMethod.post,
      "api/notes/timeline",
      (json) => misskey.Note.fromJson(json),
      body: request,
    );
  }

  Future<Iterable<misskey.Note>> getLocalTimeline(
    MisskeyTimelineRequest request,
  ) async {
    return await sendJsonRequestMultiple(
      HttpMethod.post,
      "api/notes/local-timeline",
      (json) => misskey.Note.fromJson(json),
      body: request,
    );
  }

  Future<Iterable<misskey.Note>> getHybridTimeline(
    MisskeyTimelineRequest request,
  ) async {
    return await sendJsonRequestMultiple(
      HttpMethod.post,
      "api/notes/hybrid-timeline",
      (json) => misskey.Note.fromJson(json),
      body: request,
    );
  }

  Future<Iterable<misskey.Note>> getGlobalTimeline(
    MisskeyTimelineRequest request,
  ) async {
    return await sendJsonRequestMultiple(
      HttpMethod.post,
      "api/notes/global-timeline",
      (json) => misskey.Note.fromJson(json),
      body: request,
    );
  }

  @override
  Future<void> checkResponse(Response response) async {
    if (!response.isSuccessful) {
      misskey.Error? mkErr;

      try {
        final json = await response.getContentJson();
        mkErr = misskey.Error.fromJson(json["error"]);
      } catch (ex) {
        _logger.e(
          "Failed to gather misskey.Misskey error object from erroneous response.",
          ex,
        );
      }

      if (mkErr != null) {
        throw MisskeyException(
          response.statusCode,
          mkErr,
        );
      }
    }

    super.checkResponse(response);
  }

  /// Gets your account information.
  Future<misskey.User> i() async {
    return await sendJsonRequest(
      HttpMethod.post,
      "api/i",
      (json) => misskey.User.fromJson(json),
      body: {},
    );
  }

  /// Reacts to the specified note.
  Future<misskey.User> createReaction(String noteId, String reaction) async {
    return await sendJsonRequest(
      HttpMethod.post,
      "api/notes/reactions/create",
      (json) => misskey.User.fromJson(json),
      body: {
        "noteId": noteId,
        "reaction": reaction,
      },
    );
  }

  /// Removes the reaction from the specified note.
  Future<misskey.User> deleteReaction(String noteId) async {
    return await sendJsonRequest(
      HttpMethod.post,
      "api/notes/reactions/delete",
      (json) => misskey.User.fromJson(json),
      body: {"noteId": noteId},
    );
  }

  Future<misskey.Meta> getInstanceMeta({bool detail = false}) async {
    return await sendJsonRequest(
      HttpMethod.post,
      "api/meta",
      (json) => misskey.Meta.fromJson(json),
      body: {"detail": detail},
    );
  }

  Future<Iterable<misskey.Note>> getConversation(
    String id, {
    int limit = 30,
    int offset = 0,
  }) async {
    return await sendJsonRequestMultiple(
      HttpMethod.post,
      "api/notes/conversation",
      (json) => misskey.Note.fromJson(json),
      body: {
        "noteId": id,
        "limit": limit,
        "offset": offset,
      },
    );
  }

  @override
  Future<void> setClientAuthentication(ClientSecret secret) {
    instance = secret.instance;
    return Future.value();
  }

  @override
  Future<void> setAccountAuthentication(AccountSecret secret) {
    instance = secret.instance;
    authenticationData = MisskeyAuthenticationData(secret.accessToken);
    return Future.value();
  }
}
