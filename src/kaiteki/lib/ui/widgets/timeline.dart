import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:kaiteki/di.dart';
import 'package:kaiteki/fediverse/adapter.dart';
import 'package:kaiteki/fediverse/model/post.dart';
import 'package:kaiteki/fediverse/model/timeline_type.dart';
import 'package:kaiteki/logger.dart';
import 'package:kaiteki/model/post_filters/post_filter.dart';
import 'package:kaiteki/ui/animation_functions.dart' as animations;
import 'package:kaiteki/ui/screens/conversation_screen.dart';
import 'package:kaiteki/ui/widgets/icon_landing_widget.dart';
import 'package:kaiteki/ui/widgets/status_widget.dart';
import 'package:kaiteki/utils/paged_network_stream.dart';
import 'package:mdi/mdi.dart';

class Timeline extends ConsumerStatefulWidget {
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

class TimelineState extends ConsumerState<Timeline> {
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

      if (_model.hasReachedEnd) {
        _logger.d('Reached end of timeline');
        return;
      }

      final threshold = _scrollContainer.position.maxScrollExtent - 300;
      if (threshold < _scrollContainer.offset) {
        _isLoading = true;

        _model.loadMore().then((_) {
          _isLoading = false;
        }).catchError((e) {
          _logger.e('Failed to load more posts', e);
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Iterable<Post>>(
      stream: _model.stream,
      builder: (context, snapshot) {
        return PageTransitionSwitcher(
          transitionBuilder: animations.fadeThrough,
          child: _buildStream(context, ref, snapshot),
        );
      },
    );
  }

  Widget _buildStream(
    BuildContext context,
    WidgetRef ref,
    AsyncSnapshot<Iterable<Post>> snapshot,
  ) {
    final l10n = context.getL10n();
    if (snapshot.connectionState == ConnectionState.active) {
      if (snapshot.hasError) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 40.0),
              IconLandingWidget(
                icon: const Icon(Mdi.textBoxRemove),
                text: Text(l10n.timelineRetrievalFailed),
              ),
              const SizedBox(height: 8.0),
              TextButton(
                child: Text(l10n.refresh),
                onPressed: _model.refresh,
              ),
            ],
          ),
        );
      }

      late final Map<Post, PostFilterResult> filtered;
      final filters = widget.filters ?? [];

      if (snapshot.hasData) {
        filtered = Map.fromEntries(
          snapshot.data!.map((p) {
            return MapEntry(
              p,
              PostFilter.runMultipleFilters(ref, p, filters),
            );
          }).where((p) => p.value != PostFilterResult.hide),
        );
      } else {
        filtered = <Post, PostFilterResult>{};
      }

      return RefreshIndicator(
        onRefresh: refresh,
        child: Center(
          child: filtered.isEmpty
              ? IconLandingWidget(
                  icon: const Icon(Mdi.textBoxOutline),
                  text: Text(l10n.empty),
                )
              : _buildList(filtered),
        ),
      );
    }

    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildList(Map<Post, PostFilterResult> filtered) {
    var itemCount = filtered.length;

    if (!_model.hasReachedEnd) {
      itemCount++;
    }

    return ListView.separated(
      controller: _scrollContainer,
      itemCount: itemCount,
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
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ConversationScreen(post),
            ),
          );
        },
        child: StatusWidget(post, wide: this.widget.wide),
      );

      return Center(
        child: ConstrainedBox(
          constraints: _constraints,
          child: widget,
        ),
      );
    } else if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 64.0),
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      return const SizedBox(height: 96.0);
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
    return _adapter.getTimeline(timelineType, untilId: lastId);
  }

  @override
  String takeId(Post object) {
    return object.id;
  }
}
