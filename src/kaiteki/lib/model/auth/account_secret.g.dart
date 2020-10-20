// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_secret.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountSecret _$AccountSecretFromJson(Map<String, dynamic> json) {
  return AccountSecret(
    json['identity'] == null
        ? null
        : Identity.fromJson(json['identity'] as Map<String, dynamic>),
    json['token'] as String,
  );
}

Map<String, dynamic> _$AccountSecretToJson(AccountSecret instance) =>
    <String, dynamic>{
      'identity': instance.identity,
      'token': instance.accessToken,
    };
