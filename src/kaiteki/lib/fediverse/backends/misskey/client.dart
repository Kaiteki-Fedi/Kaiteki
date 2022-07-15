import 'package:fediverse_objects/misskey.dart' as misskey;
import 'package:http/http.dart' show MultipartFile;
import 'package:kaiteki/fediverse/api_type.dart';
import 'package:kaiteki/fediverse/backends/misskey/exception.dart';
import 'package:kaiteki/fediverse/backends/misskey/requests/sign_in.dart';
import 'package:kaiteki/fediverse/backends/misskey/requests/timeline.dart';
import 'package:kaiteki/fediverse/backends/misskey/responses/check_session.dart';
import 'package:kaiteki/fediverse/backends/misskey/responses/create_app.dart';
import 'package:kaiteki/fediverse/backends/misskey/responses/generate_session.dart';
import 'package:kaiteki/fediverse/backends/misskey/responses/signin.dart';
import 'package:kaiteki/fediverse/backends/misskey/responses/userkey.dart';
import 'package:kaiteki/fediverse/client_base.dart';
import 'package:kaiteki/http/response.dart';
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
    return sendJsonRequest(
      HttpMethod.post,
      "api/app/create",
      MisskeyCreateAppResponse.fromJson,
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
    List<String>? fileIds = const [],
  }) async {
    // FIXME: Properly parse Misskey create note response
    return sendJsonRequest(
      HttpMethod.post,
      "api/notes/create",
      misskey.Note.fromJson,
      body: <String, dynamic>{
        "visibility": visibility,
        "visibleUserIds": visibleUserIds ?? [],
        if (text != null) "text": text,
        if (cw != null) "cw": cw,
        if (replyId != null) "replyId": replyId,
        if (fileIds?.isNotEmpty == true) "fileIds": fileIds,
      },
    );
  }

  Future<misskey.Note> createRenote(String renoteId) async {
    // FIXME: Properly parse Misskey create note response
    return sendJsonRequest(
      HttpMethod.post,
      "api/notes/create",
      misskey.Note.fromJson,
      body: <String, dynamic>{"renoteId": renoteId},
    );
  }

  Future<MisskeyGenerateSessionResponse> generateSession(
    String appSecret,
  ) async {
    return sendJsonRequest(
      HttpMethod.post,
      "/api/auth/session/generate",
      MisskeyGenerateSessionResponse.fromJson,
      body: {"appSecret": appSecret},
    );
  }

  Future<misskey.Page> getPage(String username, String name) async {
    return sendJsonRequest(
      HttpMethod.post,
      "api/pages/show",
      misskey.Page.fromJson,
      body: {
        "username": username,
        "name": name,
      },
    );
  }

  Future<MisskeyUserkeyResponse> userkey(String appSecret, String token) async {
    return sendJsonRequest(
      HttpMethod.post,
      "api/auth/session/userkey",
      MisskeyUserkeyResponse.fromJson,
      body: {"appSecret": appSecret, "token": token},
    );
  }

  Future<misskey.User?> showUser(String userId) async {
    return sendJsonRequest(
      HttpMethod.post,
      "api/users/show",
      misskey.User.fromJson,
      body: {"userId": userId},
    );
  }

  Future<misskey.User> showUserByName(
    String username, [
    String? instance,
  ]) async {
    final body = {"username": username};

    if (instance != null) body["instance"] = instance;

    return sendJsonRequest(
      HttpMethod.post,
      "api/users/show",
      misskey.User.fromJson,
    );
  }

  Future<Iterable<misskey.Note>> showUserNotes(
    String userId,
    bool excludeNsfw,
    Iterable<String> fileTypes,
  ) async {
    return sendJsonRequestMultiple(
      HttpMethod.post,
      "api/users/notes",
      misskey.Note.fromJson,
      body: {
        "userId": userId,
        "fileType": fileTypes,
        "excludeNsfw": excludeNsfw,
      },
    );
  }

  Future<MisskeySignInResponse> signIn(MisskeySignInRequest request) async {
    return sendJsonRequest(
      HttpMethod.post,
      "api/signin",
      MisskeySignInResponse.fromJson,
      body: request,
    );
  }

  Future<Iterable<misskey.Note>> getTimeline(
    MisskeyTimelineRequest request,
  ) async {
    return sendJsonRequestMultiple(
      HttpMethod.post,
      "api/notes/timeline",
      misskey.Note.fromJson,
      body: request,
    );
  }

  Future<Iterable<misskey.Note>> getLocalTimeline(
    MisskeyTimelineRequest request,
  ) async {
    return sendJsonRequestMultiple(
      HttpMethod.post,
      "api/notes/local-timeline",
      misskey.Note.fromJson,
      body: request,
    );
  }

  Future<Iterable<misskey.Note>> getHybridTimeline(
    MisskeyTimelineRequest request,
  ) async {
    return sendJsonRequestMultiple(
      HttpMethod.post,
      "api/notes/hybrid-timeline",
      misskey.Note.fromJson,
      body: request,
    );
  }

  Future<Iterable<misskey.Note>> getGlobalTimeline(
    MisskeyTimelineRequest request,
  ) async {
    return sendJsonRequestMultiple(
      HttpMethod.post,
      "api/notes/global-timeline",
      misskey.Note.fromJson,
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
    return sendJsonRequest(
      HttpMethod.post,
      "api/i",
      misskey.User.fromJson,
      body: {},
    );
  }

  /// Reacts to the specified note.
  Future<misskey.User> createReaction(String noteId, String reaction) async {
    return sendJsonRequest(
      HttpMethod.post,
      "api/notes/reactions/create",
      misskey.User.fromJson,
      body: {
        "noteId": noteId,
        "reaction": reaction,
      },
    );
  }

  /// Removes the reaction from the specified note.
  Future<misskey.User> deleteReaction(String noteId) async {
    return sendJsonRequest(
      HttpMethod.post,
      "api/notes/reactions/delete",
      misskey.User.fromJson,
      body: {"noteId": noteId},
    );
  }

  Future<misskey.Meta> getInstanceMeta({bool detail = false}) async {
    return sendJsonRequest(
      HttpMethod.post,
      "api/meta",
      misskey.Meta.fromJson,
      body: {"detail": detail},
    );
  }

  Future<Iterable<misskey.Note>> getConversation(
    String id, {
    int limit = 30,
    int offset = 0,
  }) async {
    return sendJsonRequestMultiple(
      HttpMethod.post,
      "api/notes/conversation",
      misskey.Note.fromJson,
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

  Future<Iterable<misskey.MessagingMessage>> getChatHistory({
    int limit = 10,
    bool group = true,
  }) async {
    return sendJsonRequestMultiple(
      HttpMethod.post,
      "api/messaging/history",
      misskey.MessagingMessage.fromJson,
      body: {limit, group},
    );
  }

  Future<Iterable<misskey.MessagingMessage>> getMessages({
    int limit = 10,
    bool markAsRead = true,
    required String? userId,
    required String? groupId,
  }) async {
    return sendJsonRequestMultiple(
      HttpMethod.post,
      "api/messaging/messages",
      misskey.MessagingMessage.fromJson,
      body: {
        if (userId != null) userId,
        if (groupId != null) groupId,
        limit,
        markAsRead,
      },
    );
  }

  Future<misskey.DriveFile> createDriveFile(
    MultipartFile file, {
    String? folderId,
    String? name,
    String? comment,

    // bool? isSensitive,
  }) {
    return sendJsonMultiPartRequest(
      HttpMethod.post,
      "api/drive/files/create",
      misskey.DriveFile.fromJson,
      fields: <String, String>{
        if (folderId != null) "folderId": folderId,
        if (name != null) "name": name,
        if (comment != null) "comment": comment,
        // if (isSensitive != null) "isSensitive": isSensitive,
      },
      files: [file],
    );
  }

  Future<MisskeyCheckSessionResponse> checkSession(String session) async {
    return sendJsonRequest(
      HttpMethod.post,
      "api/miauth/$session/check",
      MisskeyCheckSessionResponse.fromJson,
      body: {},
    );
  }
}
