 // Incomplete implementation of MusicBrainz' API.

import "dart:convert";

import "package:http/http.dart";
import "package:json_annotation/json_annotation.dart";
import "package:kaiteki_core/utils.dart";

part "listenbrainz.g.dart";

Future<ListensPayload> getNowPlaying(String username) async {
  final url = Uri(
    scheme: "https",
    host: "api.listenbrainz.org",
    pathSegments: ["1", "user", username, "playing-now"],
  );
  final response = await get(url);
  final body = utf8.decode(response.bodyBytes);
  final object = json.decode(body);
  return ListensPayload.fromJson(object["payload"]);
}

Future<LookupResponse> lookupMetadata({
  required String recordingName,
  required String artistName,
  required List<String> include,
  bool metadata = true,
}) async {
  final url = Uri(scheme: "https", host: "api.listenbrainz.org", pathSegments: [
    "1",
    "metadata",
    "lookup"
  ], queryParameters: {
    "recording_name": recordingName,
    "artist_name": artistName,
    "metadata": metadata.toString(),
    "inc": include.join(" "),
  });
  final response = await get(url);
  final body = utf8.decode(response.bodyBytes);
  final object = json.decode(body);
  return LookupResponse.fromJson(object);
}

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class LookupResponse {
  final Metadata? metadata;

  const LookupResponse({
    required this.metadata,
  });

  factory LookupResponse.fromJson(JsonMap json) =>
      _$LookupResponseFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class Metadata {
  final ReleaseMetadata? release;

  const Metadata({
    required this.release,
  });

  factory Metadata.fromJson(JsonMap json) => _$MetadataFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class ReleaseMetadata {
  final String? caaReleaseMbid;
  final int? caaId;

  const ReleaseMetadata({
    required this.caaReleaseMbid,
    required this.caaId,
  });

  factory ReleaseMetadata.fromJson(JsonMap json) =>
      _$ReleaseMetadataFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class ListensPayload {
  final List<Listen> listens;
  final int count;
  final bool? playingNow;

  const ListensPayload({
    required this.listens,
    required this.count,
    required this.playingNow,
  });

  factory ListensPayload.fromJson(JsonMap json) =>
      _$ListensPayloadFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class TrackMetadata {
  final String artistName;
  final String trackName;
  final String? releaseName;
  final AdditionalTrackMetadata? additionalInfo;

  const TrackMetadata({
    required this.artistName,
    required this.trackName,
    this.releaseName,
    this.additionalInfo,
  });

  factory TrackMetadata.fromJson(JsonMap json) => _$TrackMetadataFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class AdditionalTrackMetadata{
  final Uri? originUrl;

  const AdditionalTrackMetadata({
    this.originUrl,
  });

  factory AdditionalTrackMetadata.fromJson(JsonMap json) => _$AdditionalTrackMetadataFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class Listen {
  final bool? playingNow;
  final TrackMetadata trackMetadata;

  const Listen({this.playingNow, required this.trackMetadata});

  factory Listen.fromJson(JsonMap json) => _$ListenFromJson(json);
}
