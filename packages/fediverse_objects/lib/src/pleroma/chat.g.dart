// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Chat',
      json,
      ($checkedConvert) {
        final val = Chat(
          $checkedConvert(
              'account', (v) => Account.fromJson(v as Map<String, dynamic>)),
          $checkedConvert('id', (v) => v as String),
          $checkedConvert(
              'last_message',
              (v) => v == null
                  ? null
                  : ChatMessage.fromJson(v as Map<String, dynamic>)),
          $checkedConvert('unread', (v) => v as int),
          $checkedConvert('updated_at', (v) => DateTime.parse(v as String)),
        );
        return val;
      },
      fieldKeyMap: const {
        'lastMessage': 'last_message',
        'updatedAt': 'updated_at'
      },
    );
