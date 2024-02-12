// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reversi_game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReversiGame _$ReversiGameFromJson(Map<String, dynamic> json) => $checkedCreate(
      'ReversiGame',
      json,
      ($checkedConvert) {
        final val = ReversiGame(
          id: $checkedConvert('id', (v) => v as String),
          createdAt:
              $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
          startedAt: $checkedConvert('startedAt',
              (v) => v == null ? null : DateTime.parse(v as String)),
          isStarted: $checkedConvert('isStarted', (v) => v as bool),
          isEnded: $checkedConvert('isEnded', (v) => v as bool),
          form1: $checkedConvert('form1', (v) => v),
          form2: $checkedConvert('form2', (v) => v),
          user1Accepted: $checkedConvert('user1Accepted', (v) => v as bool),
          user2Accepted: $checkedConvert('user2Accepted', (v) => v as bool),
          user1Id: $checkedConvert('user1Id', (v) => v as String),
          user2Id: $checkedConvert('user2Id', (v) => v as String),
          user1: $checkedConvert(
              'user1', (v) => User.fromJson(v as Map<String, dynamic>)),
          user2: $checkedConvert(
              'user2', (v) => User.fromJson(v as Map<String, dynamic>)),
          winnerId: $checkedConvert('winnerId', (v) => v as String?),
          winner: $checkedConvert(
              'winner',
              (v) =>
                  v == null ? null : User.fromJson(v as Map<String, dynamic>)),
          surrendered: $checkedConvert('surrendered', (v) => v as String?),
          black: $checkedConvert('black', (v) => v as int?),
          bw: $checkedConvert('bw', (v) => v as String),
          isLlotheo: $checkedConvert('isLlotheo', (v) => v as bool),
          canPutEverywhere:
              $checkedConvert('canPutEverywhere', (v) => v as bool),
          loopedBoard: $checkedConvert('loopedBoard', (v) => v as bool),
          logs: $checkedConvert(
              'logs',
              (v) => (v as List<dynamic>?)
                  ?.map((e) => e as Map<String, dynamic>)
                  .toList()),
          map: $checkedConvert('map',
              (v) => (v as List<dynamic>?)?.map((e) => e as String).toList()),
        );
        return val;
      },
    );

Map<String, dynamic> _$ReversiGameToJson(ReversiGame instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'startedAt': instance.startedAt?.toIso8601String(),
      'isStarted': instance.isStarted,
      'isEnded': instance.isEnded,
      'form1': instance.form1,
      'form2': instance.form2,
      'user1Accepted': instance.user1Accepted,
      'user2Accepted': instance.user2Accepted,
      'user1Id': instance.user1Id,
      'user2Id': instance.user2Id,
      'user1': instance.user1,
      'user2': instance.user2,
      'winnerId': instance.winnerId,
      'winner': instance.winner,
      'surrendered': instance.surrendered,
      'black': instance.black,
      'bw': instance.bw,
      'isLlotheo': instance.isLlotheo,
      'canPutEverywhere': instance.canPutEverywhere,
      'loopedBoard': instance.loopedBoard,
      'logs': instance.logs,
      'map': instance.map,
    };
