// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_secret.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountSecret _$AccountSecretFromJson(Map<String, dynamic> json) {
  return AccountSecret(
    json['instance'] as String,
    json['user'] as String,
    json['token'] as String,
  );
}

Map<String, dynamic> _$AccountSecretToJson(AccountSecret instance) =>
    <String, dynamic>{
      'instance': instance.instance,
      'user': instance.username,
      'token': instance.accessToken,
    };
