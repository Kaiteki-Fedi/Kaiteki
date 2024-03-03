import 'package:kaiteki_core/kaiteki_core.dart';

sealed class AuxiliaryEvent {
  const AuxiliaryEvent();
}

sealed class TimelineEvent {
  const TimelineEvent();

}

class PostEvent extends TimelineEvent {
  final Post post;

  const PostEvent(this.post);
}

class PostDeletedEvent extends TimelineEvent {
  final String id;

  const PostDeletedEvent(this.id);
}

class PostEditedEvent extends TimelineEvent {
  final Post post;

  const PostEditedEvent(this.post);
}

class NotificationEvent extends AuxiliaryEvent {
  final Notification notification;

  const NotificationEvent(this.notification);

}