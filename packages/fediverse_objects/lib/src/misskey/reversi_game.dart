import 'user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reversi_game.g.dart';

@JsonSerializable()
class ReversiGame {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'createdAt')
  final DateTime createdAt;

  @JsonKey(name: 'startedAt')
  final DateTime? startedAt;

  @JsonKey(name: 'isStarted')
  final bool isStarted;

  @JsonKey(name: 'isEnded')
  final bool isEnded;

  @JsonKey(name: 'form1')
  final dynamic form1;

  @JsonKey(name: 'form2')
  final dynamic form2;

  @JsonKey(name: 'user1Accepted')
  final bool user1Accepted;

  @JsonKey(name: 'user2Accepted')
  final bool user2Accepted;

  @JsonKey(name: 'user1Id')
  final String user1Id;

  @JsonKey(name: 'user2Id')
  final String user2Id;

  @JsonKey(name: 'user1')
  final User user1;

  @JsonKey(name: 'user2')
  final User user2;

  @JsonKey(name: 'winnerId')
  final String? winnerId;

  @JsonKey(name: 'winner')
  final User? winner;

  @JsonKey(name: 'surrendered')
  final String? surrendered;

  @JsonKey(name: 'black')
  final int? black;

  @JsonKey(name: 'bw')
  final String bw;

  @JsonKey(name: 'isLlotheo')
  final bool isLlotheo;

  @JsonKey(name: 'canPutEverywhere')
  final bool canPutEverywhere;

  @JsonKey(name: 'loopedBoard')
  final bool loopedBoard;

  @JsonKey(name: 'logs')
  final List<Map<String, dynamic>>? logs;

  @JsonKey(name: 'map')
  final List<String>? map;

  const ReversiGame({
    required this.id,
    required this.createdAt,
    this.startedAt,
    required this.isStarted,
    required this.isEnded,
    this.form1,
    this.form2,
    required this.user1Accepted,
    required this.user2Accepted,
    required this.user1Id,
    required this.user2Id,
    required this.user1,
    required this.user2,
    this.winnerId,
    this.winner,
    this.surrendered,
    this.black,
    required this.bw,
    required this.isLlotheo,
    required this.canPutEverywhere,
    required this.loopedBoard,
    required this.logs,
    required this.map,
  });

  factory ReversiGame.fromJson(Map<String, dynamic> json) =>
      _$ReversiGameFromJson(json);

  Map<String, dynamic> toJson() => _$ReversiGameToJson(this);
}
