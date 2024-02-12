// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Announcement _$AnnouncementFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'Announcement',
      json,
      ($checkedConvert) {
        final val = Announcement(
          id: $checkedConvert('id', (v) => v as String),
          createdAt:
              $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
          updatedAt: $checkedConvert('updatedAt',
              (v) => v == null ? null : DateTime.parse(v as String)),
          text: $checkedConvert('text', (v) => v as String),
          title: $checkedConvert('title', (v) => v as String),
          imageUrl: $checkedConvert(
              'imageUrl', (v) => v == null ? null : Uri.parse(v as String)),
          isRead: $checkedConvert('isRead', (v) => v as bool?),
          showPopup: $checkedConvert('showPopup', (v) => v as bool?),
          isGoodNews: $checkedConvert('isGoodNews', (v) => v as bool?),
          needsConfirmationToRead:
              $checkedConvert('needsConfirmationToRead', (v) => v as bool?),
          icon: $checkedConvert('icon', (v) => v as String?),
          display: $checkedConvert('display', (v) => v as String?),
        );
        return val;
      },
    );

Map<String, dynamic> _$AnnouncementToJson(Announcement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'text': instance.text,
      'title': instance.title,
      'imageUrl': instance.imageUrl?.toString(),
      'isRead': instance.isRead,
      'showPopup': instance.showPopup,
      'isGoodNews': instance.isGoodNews,
      'needsConfirmationToRead': instance.needsConfirmationToRead,
      'icon': instance.icon,
      'display': instance.display,
    };
