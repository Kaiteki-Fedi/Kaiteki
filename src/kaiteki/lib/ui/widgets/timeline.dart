import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/fediverse/api/adapters/fediverse_adapter.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/timeline_type.dart';
import 'package:kaiteki/logger.dart';
import 'package:kaiteki/model/post_filters/post_filter.dart';
import 'package:kaiteki/ui/animation_functions.dart' as animations;
import 'package:kaiteki/ui/screens/conversation_screen.dart';
import 'package:kaiteki/ui/widgets/status_widget.dart';
import 'package:kaiteki/utils/paged_network_stream.dart';

class Timeline extends StatefulWidget {
  final FediverseAdapter adapter;
  final List<PostFilter>? filters;
  final double? maxWidth;
  final bool wide;

  const Timeline({
    Key? key,
    required this.adapter,
    this.filters,
    this.maxWidth,
    this.wide = false,
  }) : super(key: key);

  @override
  TimelineState createState() => TimelineState();
}

class TimelineState extends State<Timeline> {
  final _scrollContainer = ScrollController();
  late final TimelineModel _model;
  static final _logger = getLogger('Timeline');
  late final BoxConstraints _constraints;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _constraints = BoxConstraints(
      maxWidth: widget.maxWidth ?? double.infinity,
    );
    _model = TimelineModel(widget.adapter);

    _scrollContainer.addListener(() {
      if (_isLoading) {
        _logger.d('Already loading more posts');
        return;
      }

      var threshold = (_scrollContainer.position.maxScrollExtent - 300);
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
        return PageTransitionSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: animations.fadeThrough,
          child: _buildStream(context, snapshot),
        );
      },
    );
  }

  Widget _buildStream(
    BuildContext context,
    AsyncSnapshot<Iterable<Post>> snapshot,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    late final Map<Post, PostFilterResult> filtered;
    final filters = widget.filters ?? [];

    if (snapshot.hasData) {
      filtered = Map.fromEntries(snapshot.data!.map((p) {
        return MapEntry(
          p,
          PostFilter.runMultipleFilters(context, p, filters),
        );
      }).where((p) => p.value != PostFilterResult.hide));
    } else {
      filtered = <Post, PostFilterResult>{};
    }

    return RefreshIndicator(
      onRefresh: refresh,
      child: Center(
        child: ListView.separated(
          controller: _scrollContainer,
          itemCount: filtered.length + 1,
          separatorBuilder: (_, __) {
            if (widget.wide) {
              return const SizedBox();
            }

            return Center(
              child: ConstrainedBox(
                constraints: _constraints,
                child: const Divider(thickness: 1),
              ),
            );
          },
          itemBuilder: (context, i) => _buildItem(context, i, filtered),
        ),
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    int i,
    Map<Post, PostFilterResult> posts,
  ) {
    if (i < posts.length) {
      final post = posts.keys.elementAt(i);

      final widget = InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ConversationScreen(post),
          ));
        },
        child: StatusWidget(post, wide: this.widget.wide),
      );

      return Center(
        child: ConstrainedBox(
          constraints: _constraints,
          child: widget,
        ),
      );
    } else {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 64.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }
  }

  Future<void> refresh() async {
    await _model.refresh();
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
