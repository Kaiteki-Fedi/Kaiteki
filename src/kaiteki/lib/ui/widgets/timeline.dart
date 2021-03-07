import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/api/adapters/fediverse_adapter.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/timeline_type.dart';
import 'package:kaiteki/ui/screens/conversation_screen.dart';
import 'package:kaiteki/ui/widgets/status_widget.dart';
import 'package:kaiteki/utils/paged_network_stream.dart';

class Timeline extends StatefulWidget {
  final FediverseAdapter adapter;

  const Timeline({Key key, this.adapter}) : super(key: key);

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  final scrollController = ScrollController();
  TimelineModel timelineModel;

  @override
  void initState() {
    super.initState();

    timelineModel = TimelineModel(widget.adapter);

    scrollController.addListener(() {
      var threshold = (scrollController.position.maxScrollExtent * .95);
      if (threshold < scrollController.offset) {
        timelineModel.loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: timelineModel.stream,
      builder: (context, AsyncSnapshot<Iterable<Post>> snapshot) {
        return RefreshIndicator(
          onRefresh: timelineModel.refresh,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: scrollController,
            itemCount: (snapshot.data?.length ?? 0) + 1,
            itemBuilder: (context, i) {
              if (i < snapshot.data.length) {
                var status = snapshot.data.elementAt(i);
                return StatusWidget(status, onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ConversationScreen(status)));
                });
              } else {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
        );
      },
    );
  }
}

class TimelineModel extends PagedNetworkStream<Post, String> {
  final FediverseAdapter _adapter;
  final TimelineType timelineType;

  TimelineModel(this._adapter, {this.timelineType = TimelineType.Home});

  @override
  Future<Iterable<Post>> fetchObjects(String firstId, String lastId) async {
    return await _adapter.getTimeline(timelineType, untilId: lastId);
  }

  @override
  String takeId(Post object) {
    return object.id;
  }
}
