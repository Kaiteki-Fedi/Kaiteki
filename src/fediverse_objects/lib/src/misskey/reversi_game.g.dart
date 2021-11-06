// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reversi_game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReversiGame _$ReversiGameFromJson(Map<String, dynamic> json) => ReversiGame(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      isStarted: json['isStarted'] as bool,
      isEnded: json['isEnded'] as bool,
      form1: json['form1'],
      form2: json['form2'],
      user1Accepted: json['user1Accepted'] as bool,
      user2Accepted: json['user2Accepted'] as bool,
      user1Id: json['user1Id'] as String,
      user2Id: json['user2Id'] as String,
      user1: User.fromJson(json['user1'] as Map<String, dynamic>),
      user2: User.fromJson(json['user2'] as Map<String, dynamic>),
      winnerId: json['winnerId'] as String?,
      winner: json['winner'] == null
          ? null
          : User.fromJson(json['winner'] as Map<String, dynamic>),
      surrendered: json['surrendered'] as String?,
      black: json['black'] as int?,
      bw: json['bw'] as String,
      isLlotheo: json['isLlotheo'] as bool,
      canPutEverywhere: json['canPutEverywhere'] as bool,
      loopedBoard: json['loopedBoard'] as bool,
      logs: (json['logs'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>),
      map: (json['map'] as List<dynamic>?)?.map((e) => e as String),
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
      'logs': instance.logs?.toList(),
      'map': instance.map?.toList(),
    };
