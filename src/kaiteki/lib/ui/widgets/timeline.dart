import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/api/adapters/fediverse_adapter.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/timeline_type.dart';
import 'package:kaiteki/model/post_filters/post_filter.dart';
import 'package:kaiteki/ui/screens/conversation_screen.dart';
import 'package:kaiteki/ui/widgets/status_widget.dart';
import 'package:kaiteki/utils/paged_network_stream.dart';

class Timeline extends StatefulWidget {
  final FediverseAdapter adapter;
  final List<PostFilter>? filters;

  const Timeline({
    Key? key,
    required this.adapter,
    this.filters,
  }) : super(key: key);

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  final scrollController = ScrollController();
  late final TimelineModel timelineModel;

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
        var filtered = <Post, PostFilterResult>{};
        var filters = widget.filters ?? [];

        if (snapshot.hasData) {
          filtered = Map.fromEntries(snapshot.data!.map((p) {
            return MapEntry(
              p,
              PostFilter.runMultipleFilters(context, p, filters),
            );
          }).where((p) => p.value != PostFilterResult.Hide));
        }

        return RefreshIndicator(
          onRefresh: timelineModel.refresh,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: scrollController,
            itemCount: filtered.length + 1,
            itemBuilder: (context, i) {
              if (i < filtered.length) {
                var status = filtered.keys.elementAt(i);
                // var filterResult = filtered[status];

                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ConversationScreen(status),
                    ));
                  },
                  child: StatusWidget(status),
                );
              } else {
                var spinner = Center(child: CircularProgressIndicator());

                if (filtered.length == 0) {
                  return spinner;
                } else {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: spinner,
                  );
                }
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
  Future<Iterable<Post>> fetchObjects(String? firstId, String? lastId) async {
    return await _adapter.getTimeline(timelineType, untilId: lastId);
  }

  @override
  String takeId(Post object) {
    return object.id;
  }
}
