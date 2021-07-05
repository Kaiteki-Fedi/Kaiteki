import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/api/adapters/fediverse_adapter.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/timeline_type.dart';
import 'package:kaiteki/logger.dart';
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
  final _scrollContainer = ScrollController();
  late final TimelineModel _model;
  static final _logger = getLogger('Timeline');

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _model = TimelineModel(widget.adapter);

    _scrollContainer.addListener(() {
      if (_isLoading) {
        _logger.d('Already loading more posts');
        return;
      }

      var threshold = (_scrollContainer.position.maxScrollExtent * .95);
      if (threshold < _scrollContainer.offset) {
        _isLoading = true;
        _model.loadMore().then((_) => _isLoading = false).catchError((e) {
          _logger.e('Failed to load more posts', e);
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _model.stream,
      builder: (context, AsyncSnapshot<Iterable<Post>> snapshot) {
        var filtered = <Post, PostFilterResult>{};
        var filters = widget.filters ?? [];

        if (snapshot.hasData) {
          filtered = Map.fromEntries(snapshot.data!.map((p) {
            return MapEntry(
              p,
              PostFilter.runMultipleFilters(context, p, filters),
            );
          }).where((p) => p.value != PostFilterResult.hide));
        }

        return RefreshIndicator(
          onRefresh: _model.refresh,
          child: Scrollbar(
            controller: _scrollContainer,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollContainer,
              itemCount: filtered.length + 1,
              separatorBuilder: (_, __) {
                return const Divider(thickness: 1, height: 1);
              },
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
                  var spinner = const Center(
                    child: CircularProgressIndicator(),
                  );

                  if (filtered.isEmpty) {
                    return spinner;
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32.0),
                      child: spinner,
                    );
                  }
                }
              },
            ),
          ),
        );
      },
    );
  }
}

class TimelineModel extends PagedNetworkStream<Post, String> {
  final FediverseAdapter _adapter;
  final TimelineType timelineType;

  TimelineModel(this._adapter, {this.timelineType = TimelineType.home});

  @override
  Future<Iterable<Post>> fetchObjects(String? firstId, String? lastId) async {
    return await _adapter.getTimeline(timelineType, untilId: lastId);
  }

  @override
  String takeId(Post object) {
    return object.id;
  }
}
