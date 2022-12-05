import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:fediverse_objects/misskey.dart' as misskey;
import 'package:fediverse_objects/src/misskey/notification.dart' as misskey;
import 'package:http/http.dart'
    show MultipartFile, MultipartRequest, Request, Response;
import 'package:kaiteki/fediverse/backends/misskey/exception.dart';
import 'package:kaiteki/fediverse/backends/misskey/requests/sign_in.dart';
import 'package:kaiteki/fediverse/backends/misskey/requests/timeline.dart';
import 'package:kaiteki/fediverse/backends/misskey/responses/check_session.dart';
import 'package:kaiteki/fediverse/backends/misskey/responses/create_app.dart';
import 'package:kaiteki/fediverse/backends/misskey/responses/generate_session.dart';
import 'package:kaiteki/fediverse/backends/misskey/responses/signin.dart';
import 'package:kaiteki/fediverse/backends/misskey/responses/userkey.dart';
import 'package:kaiteki/http/http.dart';

class MisskeyClient {
  late final KaitekiClient client;

  String? i;

  MisskeyClient(String instance) {
    client = KaitekiClient(
      baseUri: Uri(scheme: "https", host: instance),
      checkResponse: _checkResponse,
      intercept: (request) {
        final i = this.i;
        if (i == null) return;

        if (request is Request) {
          // TODO(Craftplacer): we should avoid duplicate (de-)serialization.
          final map = request.bodyBytes.isEmpty ? {} : jsonDecode(request.body);
          map["i"] = i;
          request.body = jsonEncode(map);
        } else if (request is MultipartRequest) {
          request.fields["i"] = i;
        }
      },
    );
  }

  Future<CreateAppResponse> createApp(
    String name,
    String description,
    List<String> permissions, {
    String? callbackUrl,
  }) async {
    return client
        .sendRequest(
          HttpMethod.post,
          "api/app/create",
          body: {
            "name": name,
            "description": description,
            "permission": permissions,
            "callbackUrl": callbackUrl
          }.jsonBody,
        )
        .then(CreateAppResponse.fromJson.fromResponse);
  }

  Future<misskey.Note> createNote(
    String visibility, {
    List<String>? visibleUserIds,
    String? text,
    String? cw,
    String? replyId,
    List<String>? fileIds = const [],
  }) async {
    // FIXME(Craftplacer): Properly parse Misskey create note response
    return client
        .sendRequest(
          HttpMethod.post,
          "api/notes/create",
          body: <String, dynamic>{
            "visibility": visibility,
            "visibleUserIds": visibleUserIds ?? [],
            if (text != null) "text": text,
            if (cw != null) "cw": cw,
            if (replyId != null) "replyId": replyId,
            if (fileIds?.isNotEmpty == true) "fileIds": fileIds,
          }.jsonBody,
        )
        .then(misskey.Note.fromJson.fromResponse);
  }

  Future<misskey.Note> showNote(String noteId) async {
    return client
        .sendRequest(HttpMethod.get, "api/notes/show/$noteId")
        .then(misskey.Note.fromJson.fromResponse);
  }

  Future<misskey.Note> createRenote(String renoteId) async {
    // FIXME(Craftplacer): Properly parse Misskey create note response
    return client
        .sendRequest(
          HttpMethod.post,
          "api/notes/create",
          body: {"renoteId": renoteId}.jsonBody,
        )
        .then(misskey.Note.fromJson.fromResponse);
  }

  Future<GenerateSessionResponse> generateSession(
    String appSecret,
  ) async {
    return client
        .sendRequest(
          HttpMethod.post,
          "/api/auth/session/generate",
          body: {"appSecret": appSecret}.jsonBody,
        )
        .then(GenerateSessionResponse.fromJson.fromResponse);
  }

  Future<misskey.Page> getPage(String username, String name) async {
    return client
        .sendRequest(
          HttpMethod.post,
          "api/pages/show",
          body: {"username": username, "name": name}.jsonBody,
        )
        .then(misskey.Page.fromJson.fromResponse);
  }

  Future<UserkeyResponse> userkey(String appSecret, String token) async {
    return client
        .sendRequest(
          HttpMethod.post,
          "api/auth/session/userkey",
          body: {"appSecret": appSecret, "token": token}.jsonBody,
        )
        .then(UserkeyResponse.fromJson.fromResponse);
  }

  Future<misskey.User> showUser(String userId) async {
    return client
        .sendRequest(
          HttpMethod.post,
          "api/users/show",
          body: {"userId": userId}.jsonBody,
        )
        .then(misskey.User.fromJson.fromResponse);
  }

  Future<misskey.User> showUserByName(
    String username, [
    String? instance,
  ]) async {
    return client
        .sendRequest(
          HttpMethod.post,
          "api/users/show",
          body: {
            "username": username,
            if (instance != null) "instance": instance,
          }.jsonBody,
        )
        .then(misskey.User.fromJson.fromResponse);
  }

  Future<List<misskey.Note>> showUserNotes(
    String userId, {
    required bool excludeNsfw,
    required Iterable<String> fileTypes,
    String? sinceId,
    String? untilId,
  }) async {
    return client
        .sendRequest(
          HttpMethod.post,
          "api/users/notes",
          body: {
            "userId": userId,
            "fileType": fileTypes,
            if (sinceId != null) "sinceId": sinceId,
            if (untilId != null) "untilId": untilId,
            "excludeNsfw": excludeNsfw,
          }.jsonBody,
        )
        .then(misskey.Note.fromJson.fromResponseList);
  }

  Future<SignInResponse> signIn(MisskeySignInRequest request) async {
    return client
        .sendRequest(
          HttpMethod.post,
          "api/signin",
          body: request.toJson().jsonBody,
        )
        .then(SignInResponse.fromJson.fromResponse);
  }

  Future<List<misskey.Note>> getTimeline(MisskeyTimelineRequest request) async {
    return client
        .sendRequest(
          HttpMethod.post,
          "api/notes/timeline",
          body: request.toJson().jsonBody,
        )
        .then(misskey.Note.fromJson.fromResponseList);
  }

  // Have to implement checking nodeinfo for `disableLocalTimeline`
  Future<List<misskey.Note>> getLocalTimeline(
    MisskeyTimelineRequest request,
  ) async {
    return client
        .sendRequest(
          HttpMethod.post,
          "api/notes/local-timeline",
          body: request.toJson().jsonBody,
        )
        .then(misskey.Note.fromJson.fromResponseList);
  }

  // Have to implement checking nodeinfo for `disableRecommendedTimeline`
  Future<List<misskey.Note>> getBubbleTimeline(
    MisskeyTimelineRequest request,
  ) async {
    return client
        .sendRequest(
          HttpMethod.post,
          "api/notes/recommended-timeline",
          body: request.toJson().jsonBody,
        )
        .then(misskey.Note.fromJson.fromResponseList);
  }

  // Have to implement checking nodeinfo for `disableLocalTimeline` (yes, local)
  Future<Iterable<misskey.Note>> getHybridTimeline(
    MisskeyTimelineRequest request,
  ) async {
    return client
        .sendRequest(
          HttpMethod.post,
          "api/notes/hybrid-timeline",
          body: request.toJson().jsonBody,
        )
        .then(misskey.Note.fromJson.fromResponseList);
  }

  // Have to implement checking nodeinfo for `disableGlobalTimeline`
  Future<Iterable<misskey.Note>> getGlobalTimeline(
    MisskeyTimelineRequest request,
  ) async {
    return client
        .sendRequest(
          HttpMethod.post,
          "api/notes/global-timeline",
          body: request.toJson().jsonBody,
        )
        .then(misskey.Note.fromJson.fromResponseList);
  }

  Future<void> _checkResponse(Response response) async {
    if (!response.isSuccessful) {
      // HACK(Craftplacer): I threw out the usual JSON deserialization pattern from Kaiteki because adding more error-prone code (that is Misskey's fucked API schemas) to error handling is just plain stupid.
      dynamic error;

      try {
        final json = jsonDecode(response.body);
        error = json["error"];
      } catch (e, s) {
        log(
          "Failed to parse error JSON",
          error: e,
          stackTrace: s,
          name: "MisskeyClient",
        );
      }

      if (error != null) {
        throw MisskeyException(
          response.statusCode,
          error as Map<String, dynamic>,
        );
      }
    }
  }

  /// Gets your account information.
  Future<misskey.User> getI() async {
    return client //
        .sendRequest(HttpMethod.post, "api/i")
        .then(misskey.User.fromJson.fromResponse);
  }

  /// Reacts to the specified note.
  Future<void> createReaction(String noteId, String reaction) async {
    await client.sendRequest(
      HttpMethod.post,
      "api/notes/reactions/create",
      body: {"noteId": noteId, "reaction": reaction}.jsonBody,
    );
  }

  /// Removes the reaction from the specified note.
  Future<misskey.User> deleteReaction(String noteId) async {
    return client
        .sendRequest(
          HttpMethod.post,
          "api/notes/reactions/delete",
          body: {"noteId": noteId}.jsonBody,
        )
        .then(misskey.User.fromJson.fromResponse);
  }

  Future<misskey.Meta> getMeta({bool detail = false}) async {
    return client
        .sendRequest(
          HttpMethod.post,
          "api/meta",
          body: {"detail": detail}.jsonBody,
        )
        .then(misskey.Meta.fromJson.fromResponse);
  }

  Future<List<misskey.Note>> getConversation(
    String id, {
    int limit = 30,
    int offset = 0,
  }) async {
    return client
        .sendRequest(
          HttpMethod.post,
          "api/notes/conversation",
          body: {"noteId": id, "limit": limit, "offset": offset}.jsonBody,
        )
        .then(misskey.Note.fromJson.fromResponseList);
  }

  Future<misskey.DriveFile> createDriveFile(
    MultipartFile file, {
    String? folderId,
    String? name,
    String? comment,
    // bool? isSensitive,
  }) {
    return client.sendMultipartRequest(
      HttpMethod.post,
      "api/drive/files/create",
      fields: <String, String>{
        if (folderId != null) "folderId": folderId,
        if (name != null) "name": name,
        if (comment != null) "comment": comment,
        // if (isSensitive != null) "isSensitive": isSensitive,
      },
      files: [file],
    ).then(misskey.DriveFile.fromJson.fromResponse);
  }

  Future<CheckSessionResponse> checkSession(String session) async {
    return client
        .sendRequest(
          HttpMethod.post,
          "api/miauth/$session/check",
        )
        .then(CheckSessionResponse.fromJson.fromResponse);
  }

  Future<List<misskey.Note>> getRenotes(String id) async {
    return client
        .sendRequest(
          HttpMethod.post,
          "api/notes/renotes",
          body: {"noteId": id}.jsonBody,
        )
        .then(misskey.Note.fromJson.fromResponseList);
  }

  Future<void> markAllNotificationsAsRead() async {
    await client.sendRequest(
      HttpMethod.post,
      "api/notifications/mark-all-as-read",
    );
  }

  Future<List<misskey.Notification>> getNotifications({
    int? limit,
    bool? markAsRead,
    String? sinceId,
    String? untilId,
    bool? unreadOnly,
    // TODO(Craftplacer): add misskey notification types/filters
  }) async {
    return client
        .sendRequest(
          HttpMethod.post,
          "api/i/notifications",
          body: {
            if (limit != null) "limit": limit,
            if (markAsRead != null) "markAsRead": markAsRead,
            if (sinceId != null) "sinceId": sinceId,
            if (untilId != null) "untilId": untilId,
            if (unreadOnly != null) "unreadOnly": unreadOnly,
          }.jsonBody,
        )
        .then(misskey.Notification.fromJson.fromResponseList);
  }

  Future<List<misskey.UserLite>> searchUsers(
    String query, {
    int? offset,
    int? limit,
    String? origin,
    bool? detail,
  }) {
    return client
        .sendRequest(
          HttpMethod.post,
          "api/users/search",
          body: {
            "query": query,
            if (offset != null) "offset": offset,
            if (limit != null) "limit": limit,
            if (origin != null) "origin": origin,
            if (detail != null) "detail": detail,
          }.jsonBody,
        )
        .then(misskey.UserLite.fromJson.fromResponseList);
  }

  Future<List<misskey.Note>> searchNotes(
    String query, {
    String? sinceId,
    String? untilId,
    int? limit,
    int? offset,
    String? host,
    String? userId,
    String? channelId,
  }) {
    return client
        .sendRequest(
          HttpMethod.post,
          "api/notes/search",
          body: {
            "query": query,
            if (sinceId != null) "sinceId": sinceId,
            if (untilId != null) "untilId": untilId,
            if (limit != null) "limit": limit,
            if (offset != null) "offset": offset,
            if (host != null) "host": host,
            if (userId != null) "userId": userId,
            if (channelId != null) "channelId": channelId,
          }.jsonBody,
        )
        .then(misskey.Note.fromJson.fromResponseList);
  }
}
