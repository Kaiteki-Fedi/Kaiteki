// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Search _$SearchFromJson(Map<String, dynamic> json) => Search(
      statuses: (json['statuses'] as List<dynamic>?)
              ?.map((e) => Status.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      accounts: (json['accounts'] as List<dynamic>?)
              ?.map((e) => Account.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SearchToJson(Search instance) => <String, dynamic>{
      'statuses': instance.statuses,
      'accounts': instance.accounts,
    };
