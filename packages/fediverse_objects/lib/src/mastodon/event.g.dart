// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Event',
      json,
      ($checkedConvert) {
        final val = Event(
          $checkedConvert('stream',
              (v) => (v as List<dynamic>?)?.map((e) => e as String).toList()),
          $checkedConvert('event', (v) => $enumDecode(_$EventTypeEnumMap, v)),
          $checkedConvert('payload', (v) => v),
        );
        return val;
      },
    );

const _$EventTypeEnumMap = {
  EventType.update: 'update',
  EventType.delete: 'delete',
  EventType.notification: 'notification',
  EventType.filtersChanged: 'filters_changed',
  EventType.conversation: 'conversation',
  EventType.announcement: 'announcement',
  EventType.announcementReaction: 'announcement.reaction',
  EventType.announcementDelete: 'announcement.delete',
  EventType.statusUpdate: 'status.update',
  EventType.encryptedMessage: 'encrypted_message',
};
