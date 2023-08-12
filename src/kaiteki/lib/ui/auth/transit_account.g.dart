// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transit_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransitAccount _$TransitAccountFromJson(Map<String, dynamic> json) =>
    TransitAccount(
      username: json['username'] as String,
      instance: json['instance'] as String,
      apiType: $enumDecode(_$ApiTypeEnumMap, json['apiType']),
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String?,
      userId: json['userId'] as String?,
      clientId: json['clientId'] as String?,
      clientSecret: json['clientSecret'] as String?,
    );

Map<String, dynamic> _$TransitAccountToJson(TransitAccount instance) {
  final val = <String, dynamic>{
    'username': instance.username,
    'instance': instance.instance,
    'apiType': _$ApiTypeEnumMap[instance.apiType]!,
    'accessToken': instance.accessToken,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('refreshToken', instance.refreshToken);
  writeNotNull('userId', instance.userId);
  writeNotNull('clientId', instance.clientId);
  writeNotNull('clientSecret', instance.clientSecret);
  return val;
}

const _$ApiTypeEnumMap = {
  ApiType.mastodon: 'mastodon',
  ApiType.glitch: 'glitch',
  ApiType.pleroma: 'pleroma',
  ApiType.misskey: 'misskey',
  ApiType.akkoma: 'akkoma',
  ApiType.foundkey: 'foundkey',
  ApiType.calckey: 'calckey',
  ApiType.tumblr: 'tumblr',
};
