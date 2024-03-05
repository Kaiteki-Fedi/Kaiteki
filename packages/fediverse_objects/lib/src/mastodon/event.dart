import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable(createToJson: false)
class Event {
  final List<String>? stream;
  final EventType event;
  final dynamic payload;

  const Event(this.stream, this.event, this.payload);

  factory Event.fromJson(Map<String, dynamic> json) =>
      _$EventFromJson(json);
}

@JsonEnum(fieldRename: FieldRename.snake)
enum EventType {
  update,
  delete,
  notification,
  filtersChanged,
  conversation,
  announcement,
  @JsonValue("announcement.reaction")
  announcementReaction,
  @JsonValue("announcement.delete")
  announcementDelete,
  @JsonValue("status.update")
  statusUpdate,
  encryptedMessage,
  @JsonValue("pleroma:follow_relationships_update")
  pleromaFollowRelationshipsUpdate,
  @JsonValue("pleroma:respond")
  pleromaRespond,
  @JsonValue("pleroma:chat_update")
  pleromaChatUpdate,

}