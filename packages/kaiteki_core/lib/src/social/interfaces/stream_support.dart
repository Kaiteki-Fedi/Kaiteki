import 'package:kaiteki_core/model.dart';
import 'package:kaiteki_core/src/social/model/event.dart';

abstract class StreamSupport {
  Stream<TimelineEvent> listenToTimeline(TimelineType timelineType);

  Stream<AuxiliaryEvent> listenToAuxiliaryEvents();
}