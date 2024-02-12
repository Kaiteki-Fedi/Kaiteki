// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Instance _$InstanceFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Instance',
      json,
      ($checkedConvert) {
        final val = Instance(
          domain: $checkedConvert('domain', (v) => v as String),
          title: $checkedConvert('title', (v) => v as String),
          version: $checkedConvert('version', (v) => v as String),
          sourceUrl: $checkedConvert(
              'source_url', (v) => v == null ? null : Uri.parse(v as String)),
          description: $checkedConvert('description', (v) => v as String),
          usage: $checkedConvert('usage',
              (v) => InstanceUsage.fromJson(v as Map<String, dynamic>)),
          thumbnail: $checkedConvert('thumbnail',
              (v) => InstanceThumbnail.fromJson(v as Map<String, dynamic>)),
          languages: $checkedConvert('languages',
              (v) => (v as List<dynamic>).map((e) => e as String).toSet()),
          configuration: $checkedConvert('configuration',
              (v) => InstanceConfiguration.fromJson(v as Map<String, dynamic>)),
          registrations: $checkedConvert('registrations',
              (v) => InstanceRegistrations.fromJson(v as Map<String, dynamic>)),
          contact: $checkedConvert('contact',
              (v) => InstanceContact.fromJson(v as Map<String, dynamic>)),
          rules: $checkedConvert(
              'rules',
              (v) => (v as List<dynamic>)
                  .map((e) => Rule.fromJson(e as Map<String, dynamic>))
                  .toSet()),
        );
        return val;
      },
      fieldKeyMap: const {'sourceUrl': 'source_url'},
    );

Map<String, dynamic> _$InstanceToJson(Instance instance) => <String, dynamic>{
      'domain': instance.domain,
      'title': instance.title,
      'version': instance.version,
      'source_url': instance.sourceUrl?.toString(),
      'description': instance.description,
      'usage': instance.usage,
      'thumbnail': instance.thumbnail,
      'languages': instance.languages.toList(),
      'configuration': instance.configuration,
      'registrations': instance.registrations,
      'contact': instance.contact,
      'rules': instance.rules.toList(),
    };

InstanceContact _$InstanceContactFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'InstanceContact',
      json,
      ($checkedConvert) {
        final val = InstanceContact(
          $checkedConvert('email', (v) => v as String),
          $checkedConvert(
              'account',
              (v) => v == null
                  ? null
                  : Account.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$InstanceContactToJson(InstanceContact instance) =>
    <String, dynamic>{
      'email': instance.email,
      'account': instance.account,
    };

InstanceRegistrations _$InstanceRegistrationsFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'InstanceRegistrations',
      json,
      ($checkedConvert) {
        final val = InstanceRegistrations(
          $checkedConvert('enabled', (v) => v as bool),
          $checkedConvert('approval_required', (v) => v as bool),
          $checkedConvert('message', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {'approvalRequired': 'approval_required'},
    );

Map<String, dynamic> _$InstanceRegistrationsToJson(
        InstanceRegistrations instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'approval_required': instance.approvalRequired,
      'message': instance.message,
    };

InstanceThumbnail _$InstanceThumbnailFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'InstanceThumbnail',
      json,
      ($checkedConvert) {
        final val = InstanceThumbnail(
          $checkedConvert('url', (v) => Uri.parse(v as String)),
          $checkedConvert('blurhash', (v) => v as String?),
          $checkedConvert(
              'versions',
              (v) => (v as Map<String, dynamic>?)?.map(
                    (k, e) => MapEntry(k, Uri.parse(e as String)),
                  )),
        );
        return val;
      },
    );

Map<String, dynamic> _$InstanceThumbnailToJson(InstanceThumbnail instance) =>
    <String, dynamic>{
      'url': instance.url.toString(),
      'blurhash': instance.blurhash,
      'versions': instance.versions?.map((k, e) => MapEntry(k, e.toString())),
    };

InstanceUsage _$InstanceUsageFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'InstanceUsage',
      json,
      ($checkedConvert) {
        final val = InstanceUsage(
          $checkedConvert('users',
              (v) => InstanceUsageUsers.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$InstanceUsageToJson(InstanceUsage instance) =>
    <String, dynamic>{
      'users': instance.users,
    };

InstanceUsageUsers _$InstanceUsageUsersFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'InstanceUsageUsers',
      json,
      ($checkedConvert) {
        final val = InstanceUsageUsers(
          $checkedConvert('active_month', (v) => v as int),
        );
        return val;
      },
      fieldKeyMap: const {'activeMonth': 'active_month'},
    );

Map<String, dynamic> _$InstanceUsageUsersToJson(InstanceUsageUsers instance) =>
    <String, dynamic>{
      'active_month': instance.activeMonth,
    };
