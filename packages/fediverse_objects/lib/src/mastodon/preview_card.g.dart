// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preview_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreviewCard _$PreviewCardFromJson(Map<String, dynamic> json) => $checkedCreate(
      'PreviewCard',
      json,
      ($checkedConvert) {
        final val = PreviewCard(
          url: $checkedConvert('url', (v) => Uri.parse(v as String)),
          title: $checkedConvert('title', (v) => v as String),
          description: $checkedConvert('description', (v) => v as String),
          type: $checkedConvert(
              'type', (v) => $enumDecode(_$PreviewCardTypeEnumMap, v)),
          authorName: $checkedConvert('author_name', (v) => v as String?),
          authorUrl: $checkedConvert(
              'author_url', (v) => v == null ? null : Uri.parse(v as String)),
          providerName: $checkedConvert('provider_name', (v) => v as String),
          providerUrl: $checkedConvert(
              'provider_url', (v) => v == null ? null : Uri.parse(v as String)),
          html: $checkedConvert('html', (v) => v as String?),
          width: $checkedConvert('width', (v) => v as int?),
          height: $checkedConvert('height', (v) => v as int?),
          image: $checkedConvert(
              'image', (v) => v == null ? null : Uri.parse(v as String)),
          embedUrl: $checkedConvert(
              'embed_url', (v) => v == null ? null : Uri.parse(v as String)),
          blurhash: $checkedConvert('blurhash', (v) => v as String?),
          pleroma: $checkedConvert(
              'pleroma',
              (v) => v == null
                  ? null
                  : PleromaCard.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
      fieldKeyMap: const {
        'authorName': 'author_name',
        'authorUrl': 'author_url',
        'providerName': 'provider_name',
        'providerUrl': 'provider_url',
        'embedUrl': 'embed_url'
      },
    );

Map<String, dynamic> _$PreviewCardToJson(PreviewCard instance) =>
    <String, dynamic>{
      'url': instance.url.toString(),
      'title': instance.title,
      'description': instance.description,
      'type': _$PreviewCardTypeEnumMap[instance.type]!,
      'author_name': instance.authorName,
      'author_url': instance.authorUrl?.toString(),
      'provider_name': instance.providerName,
      'provider_url': instance.providerUrl?.toString(),
      'html': instance.html,
      'width': instance.width,
      'height': instance.height,
      'image': instance.image?.toString(),
      'embed_url': instance.embedUrl?.toString(),
      'blurhash': instance.blurhash,
      'pleroma': instance.pleroma,
    };

const _$PreviewCardTypeEnumMap = {
  PreviewCardType.link: 'link',
  PreviewCardType.photo: 'photo',
  PreviewCardType.video: 'video',
  PreviewCardType.rich: 'rich',
};

TrendsLink _$TrendsLinkFromJson(Map<String, dynamic> json) => $checkedCreate(
      'TrendsLink',
      json,
      ($checkedConvert) {
        final val = TrendsLink(
          url: $checkedConvert('url', (v) => Uri.parse(v as String)),
          title: $checkedConvert('title', (v) => v as String),
          description: $checkedConvert('description', (v) => v as String),
          type: $checkedConvert(
              'type', (v) => $enumDecode(_$PreviewCardTypeEnumMap, v)),
          authorName: $checkedConvert('author_name', (v) => v as String?),
          providerName: $checkedConvert('provider_name', (v) => v as String),
          html: $checkedConvert('html', (v) => v as String?),
          width: $checkedConvert('width', (v) => v as int?),
          height: $checkedConvert('height', (v) => v as int?),
          history: $checkedConvert(
              'history',
              (v) => (v as List<dynamic>)
                  .map((e) => TrendsHistory.fromJson(e as Map<String, dynamic>))
                  .toList()),
        );
        return val;
      },
      fieldKeyMap: const {
        'authorName': 'author_name',
        'providerName': 'provider_name'
      },
    );

Map<String, dynamic> _$TrendsLinkToJson(TrendsLink instance) =>
    <String, dynamic>{
      'url': instance.url.toString(),
      'title': instance.title,
      'description': instance.description,
      'type': _$PreviewCardTypeEnumMap[instance.type]!,
      'author_name': instance.authorName,
      'provider_name': instance.providerName,
      'html': instance.html,
      'width': instance.width,
      'height': instance.height,
      'history': instance.history,
    };
