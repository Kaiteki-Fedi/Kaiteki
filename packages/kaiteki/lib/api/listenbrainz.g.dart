// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listenbrainz.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LookupResponse _$LookupResponseFromJson(Map<String, dynamic> json) =>
    LookupResponse(
      metadata: json['metadata'] == null
          ? null
          : Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );

Metadata _$MetadataFromJson(Map<String, dynamic> json) => Metadata(
      release: json['release'] == null
          ? null
          : ReleaseMetadata.fromJson(json['release'] as Map<String, dynamic>),
    );

ReleaseMetadata _$ReleaseMetadataFromJson(Map<String, dynamic> json) =>
    ReleaseMetadata(
      caaReleaseMbid: json['caa_release_mbid'] as String?,
      caaId: json['caa_id'] as int?,
    );

ListensPayload _$ListensPayloadFromJson(Map<String, dynamic> json) =>
    ListensPayload(
      listens: (json['listens'] as List<dynamic>)
          .map((e) => Listen.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: json['count'] as int,
      playingNow: json['playing_now'] as bool?,
    );

TrackMetadata _$TrackMetadataFromJson(Map<String, dynamic> json) =>
    TrackMetadata(
      artistName: json['artist_name'] as String,
      trackName: json['track_name'] as String,
      releaseName: json['release_name'] as String?,
      additionalInfo: json['additional_info'] == null
          ? null
          : AdditionalTrackMetadata.fromJson(
              json['additional_info'] as Map<String, dynamic>),
    );

AdditionalTrackMetadata _$AdditionalTrackMetadataFromJson(
        Map<String, dynamic> json) =>
    AdditionalTrackMetadata(
      originUrl: json['origin_url'] == null
          ? null
          : Uri.parse(json['origin_url'] as String),
    );

Listen _$ListenFromJson(Map<String, dynamic> json) => Listen(
      playingNow: json['playing_now'] as bool?,
      trackMetadata: TrackMetadata.fromJson(
          json['track_metadata'] as Map<String, dynamic>),
    );
